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
      # User.destroy_all
      # p client.members.body['members']
      client.members.body['members']&.each do |member|
        new_user = User.new
        new_user.update(member)
        new_user.save!
      end

      # Post.destroy_all
      # p client.posts.body['posts']
      client.posts.body['posts']&.each do |post|
        new_post = Post.new
        ignore_attributes = %w(updated_at created_by updated_by sharing_urls)
        new_post.update(post.reject {|k,v| ignore_attributes.include?(k)})
        new_post.updated_at = DateTime.new(post[:updated_at])
        new_post.created_by = User.where(name: post[:created_by][:name])
        new_post.updated_by = User.where(name: post[:updated_by][:name])
        new_post.save!
      end
    end
  end
end
