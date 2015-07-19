class Following
  include Mongoid::Document
  
  field :username,    type: String
  field :created_at,  type: Date

  validates :username, presence: true

  embedded_in :user
end
