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
      action: "liked your card",
      target_type: "Card",
      target_link: nil,
      target_id: self.card_id,
      target_identifier: nil,
      when: self.created_at
    }
  end
end
