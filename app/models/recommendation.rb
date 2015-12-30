class Recommendation < ActiveRecord::Base
  validates :from_user_id, presence: true
  validates :to_user_id, presence: true
  validates :recommendable_id, presence: true
  validates :recommendable_type, presence: true

  belongs_to :from_user, class_name: "User"
  belongs_to :to_user, class_name: "User"
  belongs_to :recommendable, polymorphic: true

  has_many :notifications, as: :notifier, dependent: :destroy

  def message
    {
      who: self.from_user_id,
      action: "recommended:#{self.recommendable_type}",
      target_type: "#{self.recommendable_type}",
      target_id: self.recommendable_id,
      when: time_ago_in_words self.created_at
    }.to_json
  end
end
