class Favorite < ActiveRecord::Base
  belongs_to :deck
  belongs_to :user
  validates :deck_id, presence: true
  validates :user_id, presence: true
end
