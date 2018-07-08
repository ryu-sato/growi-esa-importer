require 'esa'
require 'crowi-client'
require 'json'
require 'open-uri'
require 'tmpdir'

namespace :esa do
  desc "esa からデータを取得してDBへ保存する"
  task :import_to_db => :environment do

    # esa Client を初期化
    esa_access_token = ENV["ESA_ACCESS_TOKEN"] || Setting.first&.esa_access_token
    esa_current_team = ENV['ESA_CURRENT_TEAM'] || Setting.first&.esa_team
    esaclient = Esa::Client.new(access_token: esa_access_token, current_team: esa_current_team)

    # インポートが完了するまでを一連のトランザクションとする
    ActiveRecord::Base.transaction do
      # データを全て破棄する
      User.destroy_all
      Post.destroy_all
      Comment.destroy_all
      Attachment.destroy_all

      # ユーザをインポートする
      esaclient.members.body['members']&.each {|member| User.create(member) }

      # 記事をインポートする
      esaclient.posts.body['posts']&.each do |post|
        ignore_attributes = %w(created_by updated_by tags sharing_urls)
        post_attributes = post.reject {|k,v| ignore_attributes.include?(k)}.merge({
          created_by:    User.find_by(name: post["created_by"]["name"]) || User.create(post["created_by"]),
          updated_by:    User.find_by(name: post["updated_by"]["name"]) || User.create(post["updated_by"]),
          tags:          Array.new(post["tags"])
        })
        p Post.create(post_attributes)
      end

      # コメントをインポートする
      Post.all.each do |post|
        esaclient.comments(post.number).body['comments']&.each do |comment|
          ignore_attributes = %w(created_by)
          comment_attributes = comment.reject {|k,v| ignore_attributes.include?(k)}.merge({
            post:       post,
            created_by: User.find_by(name: comment["created_by"]["name"]) || User.create(comment["created_by"])
          })
          p Comment.create(comment_attributes)
        end
      end

      # 添付ファイルをダウンロードしてインポートする
      Post.all.each do |post|
        post.body_md.scan /\[([^\[\]]+)\]\(([^()]+)\)/ do |link_text, link_href|
          attachment = Attachment.new(url: link_href)
          next unless attachment.match_attachment_url? # esa の添付ファイル用URLでは無ければスルー

          attachment_url = open(link_href)
          attachment.update(post: post, url: link_href, data: attachment_url.read)
          p attachment
        end
      end
    end
  end

  desc "esa のデータ形式を GROWI の形式に変更する"
  task :convert_to_growi => :environment do
    # [Note] Markdown で未対応のものがあればここに記述する

    # バグ対策
    ## ファイル名が .md で終わっていると GROWI が .md を無視したページとして認識する
    Post.all.each do |post|
      new_name = post.name.gsub(/\.md(.*)$|\.md(\/)/, '\1')
      post.update(name: new_name)
    end
  end

  desc "DBのデータを GROWI へ保存する"
  task :export_to_growi => :environment do

    # Crowi(GROWIも可) client を初期化
    crowi_url = ENV['CROWI_URL'] || Setting.first&.crowi_url
    crowi_access_token = ENV["CROWI_ACCESS_TOKEN"] || Setting.first&.crowi_access_token
    crowiclient = CrowiClient.new(crowi_url: crowi_url, access_token: crowi_access_token)

    # 記事を GRWOI へ保存する
    Post.all.each do |post|

      # esa のカテゴリと記事名から GRWOI の path を作成する
      growi_page_path = '/' + [post.category, post.name].compact.join('/')

      # 記事を GROWI へ保存する
      if crowiclient.page_exist?(path_exp: growi_page_path)
        # 記事の内容を更新する
        page_id = crowiclient.page_id path_exp: growi_page_path
        req_update_page = CPApiRequestPagesUpdate.new(
                            page_id: page_id, body: post.body_md)
        res = crowiclient.request req_update_page
        (p res.msg && next) if res.kind_of? CPInvalidRequest
        p res.data
      else
        # 記事が無ければ作成する
        req_create_page = CPApiRequestPagesCreate.new(
                            path: growi_page_path, body: post.body_md)
        res = crowiclient.request req_create_page
        (p res.msg && next) if res.kind_of? CPInvalidRequest
        p res.data
        page_id = res.data.id
      end
      next unless page_id # 新規作成できているはずだが一応 page_id を取得できなければスルー

      # 添付ファイルをアップロードする
      body_md = post.body_md  # 添付ファイルをアップロードする度に書き換えるようの変数
      Attachment.where(post: post).each do |attachment|
        next if crowiclient.attachment_exist?(path_exp: growi_page_path,
                                              attachment_name: attachment.filename) # 既に添付ファイルがある場合はスルー

        # 添付ディレクトリ配下にファイルを作成してから添付ファイルをアップロード
        Dir.mktmpdir do |tmp_dir|
          attachment_file_name = File.join(tmp_dir, attachment.filename)

          File.open(attachment_file_name, 'w') do |tmp_file|
            tmp_file.binmode
            tmp_file.write(attachment.data)
          end

          File.open(attachment_file_name, 'r') do |tmp_file|
            # 添付ファイルをアップロード
            req_add_attachment = CPApiRequestAttachmentsAdd.new(
                                   page_id: page_id, file: tmp_file)
            res = crowiclient.request req_add_attachment
            (p res.msg && next) if res.kind_of? CPInvalidRequest
            p res.data
          end

          # アップロードした添付ファイルを元に記事のリンクを置き換える
          req_get_attachment_list = CPApiRequestAttachmentsList.new page_id: page_id
          res = crowiclient.request req_get_attachment_list
          (p res.msg && next) if res.kind_of? CPInvalidRequest
          growi_attachment = res.data.find {|item| item.originalName == attachment.filename}
          next if growi_attachment.nil?

          new_body_md = body_md.gsub(/\[([^\[\]]+)\]\(#{attachment.url}\)/, "[\\1](#{growi_attachment.url})")
          req_update_page = CPApiRequestPagesUpdate.new(
                              page_id: page_id, body: new_body_md)
          res = crowiclient.request req_update_page
          (p res.msg && next) if res.kind_of? CPInvalidRequest
          p res.data

          body_md = new_body_md
        end
      end
    end
  end
end
