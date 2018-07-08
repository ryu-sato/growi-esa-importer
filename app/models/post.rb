# == Schema Information
#
# Table name: posts
#
#  id               :integer          not null, primary key
#  number           :integer          default(0), not null
#  name             :string           default(""), not null
#  tags             :text             default("--- []\n"), not null
#  category         :string
#  full_name        :string           default(""), not null
#  wip              :boolean          default(FALSE), not null
#  body_md          :string           default(""), not null
#  body_html        :string           default(""), not null
#  created_at       :datetime         not null
#  updated_at       :datetime
#  url              :string           default(""), not null
#  message          :string           default(""), not null
#  revision_number  :integer          default(0), not null
#  created_by_id    :integer          not null
#  updated_by_id    :integer          not null
#  kind             :string           default(""), not null
#  comments_count   :integer          default(0), not null
#  tasks_count      :integer          default(0), not null
#  done_tasks_count :integer          default(0), not null
#  stargazers_count :integer          default(0), not null
#  watchers_count   :integer          default(0), not null
#  star             :boolean          default(FALSE), not null
#  watch            :boolean          default(FALSE), not null
#  lock_version     :integer          default(0), not null
#

class Post < ApplicationRecord
  belongs_to :created_by, class_name: "User", foreign_key: "created_by_id"
  belongs_to :updated_by, class_name: "User", foreign_key: "updated_by_id"
  has_many :comments
end
