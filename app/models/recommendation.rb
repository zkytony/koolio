class Recommendation < ActiveRecord::Base
  validates :from_user_id, presence: true
  validates :to_user_id, presence: true
  validates :recommendable_id, presence: true
  validates :recommendable_type, presence: true

  belongs_to :from_user, class_name: "User"
  belongs_to :to_user, class_name: "User"
  belongs_to :recommendable, polymorphic: true

  has_many :notifications, as: :notifier, dependent: :destroy
end
