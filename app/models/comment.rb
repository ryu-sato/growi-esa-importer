# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  body_md          :string           default(""), not null
#  body_html        :string           default(""), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  url              :string
#  created_by_id    :integer          not null
#  stargazers_count :integer          default(0), not null
#  star             :boolean          default(FALSE), not null
#  lock_version     :integer          default(0), not null
#

class Comment < ApplicationRecord
  belongs_to :created_by, class_name: "User", foreign_key: "created_by_id"
end
