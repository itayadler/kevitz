class Collage < ActiveRecord::Base
  has_attached_file :image, :default_url => "/images/:style/missing.png", storage: :s3, 
  s3_credentials: Proc.new{|a| a.instance.s3_credentials }
  do_not_validate_attachment_file_type :image

  def s3_credentials
    {
      bucket: ENV['S3_BUCKET'], 
      access_key_id: ENV['S3_ACCESS_KEY_ID'], 
      secret_access_key: ENV['S3_SECRET_ACCESS_KEY']
    }
  end
end