class LikeComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment
  validates :user_id, presence: true
  validates :comment_id, presence: true

  has_many :notifications, as: :notifier, dependent: :destroy

  def message
    {
      who: self.user.username,
      who_id: self.user.id,
      who_link: "/users/#{self.user.id}/profile",
      action: "liked your comment",
      target_type: "Comment",
      target_link: nil,
      target_id: self.comment.id,
      target_identifier: "#{self.comment.content[0, 10]}...",
      when: self.created_at
    }
  end
end
