class LikeCard < ActiveRecord::Base
  belongs_to :user
  belongs_to :card
  validates :user_id, presence: true
  validates :card_id, presence: true

  has_many :notifications, as: :notifier, dependent: :destroy

  def message
    {
      who: self.user.username,
      who_id: self.user.id,
      who_link: "/users/#{self.user.id}/profile",
      action: "liked your",
      target_type: "Card",
      target_link: "/cards/#{self.card.id}/",
      target_id: self.card_id,
      target_identifier: "card",
      when: self.created_at
    }
  end
end
