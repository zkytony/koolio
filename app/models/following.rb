class Following < ActiveRecord::Base
  belongs_to :follower, class_name: "User"   # Follow others
  belongs_to :followee, class_name: "User"  # Being followed by others

  validates :follower_id, presence: true
  validates :followee_id, presence: true
end
