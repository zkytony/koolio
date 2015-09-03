class Card < ActiveRecord::Base
  validates :deck_id, presence: true
  validates :user_id, presence: true
  
  belongs_to :deck
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :users_with_like, class_name: "LikeCard", dependent: :destroy
  has_many :liked_users, through: :users_with_like, source: :user
end
