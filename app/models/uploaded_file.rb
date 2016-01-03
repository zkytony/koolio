class UploadedFile < ActiveRecord::Base
  belongs_to :user

  attr_accessor :coords
  mount_uploader :name, UserFileUploader

  validates :user_id, presence: true
  validates :name, presence: true
  validates :type, presence: true,
                   length: { maximum: 255 }

end
