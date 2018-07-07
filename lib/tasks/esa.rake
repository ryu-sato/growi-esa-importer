require 'esa'
require 'crowi-client'
require 'json'

namespace :esa do
  desc "esa からデータを取得してDBへ保存する"
  task :export_to_db => :environment do

    # esa Client を初期化
    Dotenv.load
    esaclient = Esa::Client.new(access_token: ENV["ESA_ACCESS_TOKEN"], current_team: ENV['ESA_CURRENT_TEAM'])

    # インポートが完了するまでを一連のトランザクションとする
    ActiveRecord::Base.transaction do
      # データを全て破棄する
      User.destroy_all
      Post.destroy_all
      Comment.destroy_all

      # ユーザをインポートする
      esaclient.members.body['members']&.each {|member| User.create(member) }

      # 記事をインポートする
      esaclient.posts.body['posts']&.each do |post|
        new_post = Post.new
        new_post.created_by = User.find_by(name: post["created_by"]["name"]) || User.create(post["created_by"])
        new_post.updated_by = User.find_by(name: post["updated_by"]["name"]) || User.create(post["updated_by"])
        new_post.tags = Array.new post["tags"]
        ignore_attributes = %w(created_by updated_by sharing_urls tags)
        post.reject {|k,v| ignore_attributes.include?(k)}.each {|k,v| new_post.send(k + "=", v) }
        new_post.save!
      end

      # コメントをインポートする
      Post.all.each do |post|
        p '--- comments'
        p esaclient.comments(post.number).body['comments']
        esaclient.comments(post.number).body['comments']&.each do |comment|
          new_comment = Comment.new
          new_comment.created_by = User.find_by(name: comment["created_by"]["name"]) || User.create(comment["created_by"])
          new_comment.post = post
          ignore_attributes = %w(created_by)
          comment.reject {|k,v| ignore_attributes.include?(k)}.each {|k,v| new_comment.send(k + "=", v) }
          new_comment.save!
        end
      end

      # [TODO] 添付ファイルをインポートする
    end
  end

  desc "DBのデータを GROWI へ保存する"
  task :import_from_db => :environment do

    # Crowi(GROWIも可) client を初期化
    crowiclient = CrowiClient.instance

    # 記事を GRWOI へ保存する
    Post.all.each do |post|
      res = crowiclient.request CPApiRequestPagesCreate.new path: post.name, body: post.body_md
      next if res.ok

      # 記事にコメントを保存する
      Comment.where()
    end
  end
end
