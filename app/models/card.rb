class Card < ActiveRecord::Base
  validates :deck_id, presence: true
  validates :user_id, presence: true
  
  belongs_to :deck
  belongs_to :user
end
