class DeckUserAssociation < ActiveRecord::Base
  validates :user_id, presence: true
  validates :deck_id, presence: true
  validates :type, presence: true

  belongs_to :user
  belongs_to :deck

  has_many :notifications, as: :notifier, dependent: :destroy

  def message
    {
      who: self.user_id,
      action: "shared deck:#{self.type}",
      target_type: "Deck",
      target_id: self.deck_id, 
      when: self.created_at
    }.to_json
  end
end
