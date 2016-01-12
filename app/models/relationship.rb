class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  has_many :notifications, as: :notifier, dependent: :destroy

  # as a notifier of followed by a user
  def message
    {
      who: self.follower.username,
      who_id: self.follower_id,
      who_link: "/users/#{self.follower_id}/profile",
      action: "followed",
      target_type: "User",
      target_id: self.followed_id,
      target_identifier: "you",
      when: self.created_at
    }
  end
end
