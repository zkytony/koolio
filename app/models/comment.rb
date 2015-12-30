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

  has_many :notifications, as: :notifier,  dependent: :destroy

  def message
    {
      who: self.user.username,
      who_id: self.user.id,
      who_link: "/users/#{self.user.id}/profile",
      action: "commented on your card",
      target_type: "Card",
      target_link: nil,
      target_id: self.card_id,
      target_identifier: "#{self.content[0, 10]}...",
      when: self.created_at
    }
  end
end
