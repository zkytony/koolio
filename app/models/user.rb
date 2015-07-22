class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :username,   type: String
  field :first_name, type: String
  field :last_name,  type: String
  field :email,      type: String
  field :password_digest, type: String
  field :birthday,   type: Date
  field :male,       type: Boolean
  field :activated,  type: Boolean, default: false
  field :_id,        type: String,  default: -> { username } # Custom id

  has_many :decks,    dependent: :delete
  has_many :cards,    dependent: :delete
  has_many :comments, dependent: :delete

  index({ username: 1 }, { unique: true, drop_dups: true })

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username,  presence: true,
                        uniqueness: true
  validates :email,     presence: true,
                        uniqueness: true,
                        format: { with: VALID_EMAIL_REGEX },
                        length: { maximum: 255 }
  validates :password,  presence: true,
                        length: { minimum: 6 }
  validates :activated, presence: true
  
  has_secure_password   # Enforces validation on the virtual password & password_confirmation attributes
end
