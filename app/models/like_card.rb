class LikeCard < ActiveRecord::Base
  belongs_to :user
  belongs_to :card
  validates :user_id, presence: true
  validates :card_id, presence: true
end
