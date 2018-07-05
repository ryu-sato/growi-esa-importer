# == Schema Information
#
# Table name: users
#
#  id           :integer          not null, primary key
#  name         :string           default(""), not null
#  screen_name  :string           default(""), not null
#  icon         :string           default(""), not null
#  email        :string           default(""), not null
#  posts_count  :integer          default(0), not null
#  lock_version :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class User < ApplicationRecord
  has_many :posts
end
