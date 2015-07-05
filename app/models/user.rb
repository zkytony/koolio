class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username,   type: String
  field :first_name, type: String
  field :last_name,  type: String
  field :email,      type: String
  field :password,   type: String
  field :birthday,   type: Date
  field :male,       type: Boolean
  field :activated,  type: Boolean
  field :_id,        type: String, default: -> { username } # Custom id

  validates :username,  presence: true
  validates :email,     presence: true
  validates :password,  presence: true
  validates :activated, presence: true

end
