class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  has_many :notifications, as: :notifier, dependent: :destroy

  # as a notifier of followed by a user
  def message
    {
      who: self.follower_id,
      action: "followed by",
      target_type: nil,
      target_id: nil,
      when: self.created_at
    }.to_json
  end
end
