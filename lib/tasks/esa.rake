require 'esa'
require 'json'

namespace :esa do
  desc "esa からデータを取得してローカルのDBへ保存する"

  task :import_to_db => :environment do

    # esa Client を初期化
    Dotenv.load
    client = Esa::Client.new(access_token: ENV["ESA_ACCESS_TOKEN"], current_team: ENV['ESA_CURRENT_TEAM'])

    # モデルをすべて削除してから解析したモデルを追加する
    ActiveRecord::Base.transaction do
      User.destroy_all
      client.members.body['members']&.each {|member| User.create(member) }

      Post.destroy_all
      client.posts.body['posts']&.each do |post|
        # puts '---- add post'
        # p post
        # puts '--- User.find_by name: post["created_by"]["name"]'
        # p User.find_by name: post["created_by"]["name"]
        # puts '--- post["created_by"]'
        # p post["created_by"]
        # puts '--- post["created_by"]["name"]'
        # p post["created_by"]["name"]

        new_post = Post.new
        new_post.created_by = User.find_by(name: post["created_by"]["name"]) || User.create(post["created_by"])
        new_post.updated_by = User.find_by(name: post["updated_by"]["name"]) || User.create(post["updated_by"])
        new_post.tags = Array.new post["tags"]
        ignore_attributes = %w(created_by updated_by sharing_urls tags)
        post.reject {|k,v| ignore_attributes.include?(k)}.each {|k,v| new_post.send(k + "=", v) }
        puts '---- new post'
        p new_post
        new_post.save!
      end
    end
  end
end
