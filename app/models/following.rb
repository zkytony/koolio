class Following
  include Mongoid::Document
  
  field :followee,    type: String
  field :follower,    type: String
  field :created_at,  type: Date
  field :end_at,      type: Date

  validates :followee, presence: true
  validates :follower, presence: true
  validates :created_at, presence: true

end
