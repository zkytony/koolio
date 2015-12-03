class LikeComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment
  validates :user_id, presence: true
  validates :comment_id, presence: true

  has_many :notifications, as: :notifier, dependent: :destroy
end
