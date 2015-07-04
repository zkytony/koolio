class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nickname,   type: String
  field :first_name, type: String
  field :last_name,  type: String
  field :email,      type: String
  field :password,   type: String
  field :birthday,   type: Date
  field :male,       type: Boolean
  field :activated,  type: Boolean
  field :_id,        type: String, default: -> { nickname } # Custom id

end
