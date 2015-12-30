class Favorite < ActiveRecord::Base
  belongs_to :deck
  belongs_to :user
  validates :deck_id, presence: true
  validates :user_id, presence: true

  has_many :notifications, as: :notifier, dependent: :destroy

  def message
    {
      who: self.user_id,
      action: "favorited deck",
      target_type: "Deck",
      target_id: self.deck_id,
      when: self.created_at
    }.to_json
  end
end
