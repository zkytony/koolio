class Subscription < ActiveRecord::Base

  field :subscriber,    type: String
  field :deck_id,       type: String
  field :created_at,  type: Date
  field :end_at,      type: Date

  belongs_to :deck

  validates :subscriber, presence: true
  validates :deck_id, presence: true
  validates :created_at, presence: true

end
