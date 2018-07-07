# == Schema Information
#
# Table name: attachments
#
#  id           :integer          not null, primary key
#  data         :binary(10485760)
#  url          :string
#  post_id      :integer          not null
#  lock_version :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Attachment < ApplicationRecord
  belongs_to :post

  # URL のファイル名を取得する
  def filename
    File.basename(self.url)
  end

  # URL が添付ファイルであるかどうか bool 値を返す
  def match_attachment_url?
    match_image_url? || match_non_image_url?
  end

  # URL が添付画像であるかどうか bool 値を返す
  def match_image_url?
    image_url_re = /https?:\/\/img\.esa\.io\/uploads\/production\/attachments\/\d+\/\d+\/\d+\/\d+\/\d+\/[^\/]+/
    self.url&.match image_url_re
  end

  # URL が画像以外の添付ファイルであるかどうか bool 値を返す
  def match_non_image_url?
    non_image_url_re = /https?:\/\/esa-storage-tokyo\.s3-ap-northeast-1\.amazonaws\.com\/uploads\/production\/attachments\/\d+\/\d+\/\d+\/\d+\/\d+\/[^\/]+/
    self.url&.match non_image_url_re
  end
end
