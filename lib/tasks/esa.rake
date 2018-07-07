require 'esa'
require 'crowi-client'
require 'json'
require 'open-uri'
require 'tmpdir'

namespace :esa do
  desc "esa からデータを取得してDBへ保存する"
  task :import_to_db => :environment do

    # esa Client を初期化
    Dotenv.load
    esaclient = Esa::Client.new(access_token: ENV["ESA_ACCESS_TOKEN"], current_team: ENV['ESA_CURRENT_TEAM'])

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
        ignore_attributes = %w(created_by updated_by sharing_urls tags)
        post_attributes = post.reject {|k,v| ignore_attributes.include?(k)}.merge({
          created_by: User.find_by(name: post["created_by"]["name"]) || User.create(post["created_by"]),
          updated_by: User.find_by(name: post["updated_by"]["name"]) || User.create(post["updated_by"]),
          tags:       Array.new(post["tags"])
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
    crowiclient = CrowiClient.instance

    # 記事を GRWOI へ保存する
    Post.all.each do |post|

      # esa のカテゴリと記事名から GRWOI の path を作成する
      path = '/' + [post.category, post.name].compact.join('/')

      # 記事を GROWI へ保存する
      if crowiclient.page_exist?(path_exp: path)
        # 記事の内容を更新する
        page_id = crowiclient.page_id path_exp: path
        req_update_page = CPApiRequestPagesUpdate.new(
                            page_id: page_id, body: post.body_md)
        res = crowiclient.request req_update_page
        (p res.msg && next) if res.kind_of? CPInvalidRequest
        p res.data
      else
        # 記事が無ければ作成する
        req_create_page = CPApiRequestPagesCreate.new(
                            path: path, body: post.body_md)
        res = crowiclient.request req_create_page
        (p res.msg && next) if res.kind_of? CPInvalidRequest
        p res.data
        page_id = res.data.id
      end

      # 添付ファイルをアップロードする
      next unless page_id # 新規作成できているはずだが一応 page_id を取得できなければスルー
      Attachment.where(post: post).each do |attachment|

        # 添付ファイルをアップロード
        Dir.mktmpdir do |tmp_dir|
          File.open(File.join(tmp_dir, attachment.filename), 'w') do |tmp_file|
            tmp_file.binmode
            tmp_file.write(attachment.data)

            # 添付ファイルをアップロード
            req_add_attachment = CPApiRequestAttachmentsAdd.new(
                                   page_id: page_id, file: tmp_file.path)
            res = crowiclient.request req_add_attachment
            (p res.msg && next) if res.kind_of? CPInvalidRequest
            p res.data

            # アップロードした添付ファイルを元に記事のリンクを置き換える
            req_get_attachment_list = CPApiRequestAttachmentsList.new page_id: page_id
            res = crowiclient.request req_get_attachment_list
            (p res.msg && next) if res.kind_of? CPInvalidRequest
            p res.data
            growi_attachment = res.data.find(originalName: attachment.filename)

            new_body_md = post.body_md.gsub(/[^(\[\]+)]\([^\(\)]+\)/, "[\\1](#{growi_attachment.url})")
            post.update(body_md: new_body_md)
            req_update_page = CPApiRequestPagesUpdate.new(
              page_id: page_id, body: post.body_md)
            res = crowiclient.request req_update_page
            (p res.msg && next) if res.kind_of? CPInvalidRequest
            p res.data
          end
        end
      end
    end
  end
end
