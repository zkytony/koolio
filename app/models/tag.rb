class Tag < ActiveRecord::Base

  field :name,       type: String
  field :created_at, type: DateTime
  field :_id,        type: String, default: -> { name }
  
  validates :name, presence: true

end
