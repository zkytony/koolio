class DeckUserAssociation < ActiveRecord::Base
  validates :user_id, presence: true
  validates :deck_id, presence: true
  validates :type, presence: true

  belongs_to :user
  belongs_to :deck
end
