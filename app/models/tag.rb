class Tag
  include Mongoid::Document

  field :name,       type: String
  field :created_at, type: DateTime
  field :_id,        type: String, default: -> { name }
  
  validates :name, presence: true

end
