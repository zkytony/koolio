class Comment < ActiveRecord::Base
  validates :user_id, presence: true
  validates :card_id, presence: true
  validates :content, presence: true

  # like feature for comments is not available right now
  has_many :users_with_like, class_name: "LikeComment", dependent: :destroy
  has_many :liked_users, through: :users_with_like, source: :user

  belongs_to :user
  belongs_to :card

  has_many :activities, as: :trackable, dependent: :destroy
end
