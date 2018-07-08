# == Schema Information
#
# Table name: settings
#
#  id                 :integer          not null, primary key
#  esa_access_token   :string
#  esa_team           :string
#  crowi_access_token :string
#  crowi_url          :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Setting < ApplicationRecord
end
