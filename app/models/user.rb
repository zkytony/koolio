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
  index({ email: 1 }, { unique: true, drop_dups: true })

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

  def self.find_by_email(email)
    where(email: email).first
  end

  def self.find_by_username(username)
    where(username: username).first
  end

  def self.authenticate(identifier, password)
    user = find_by_username identifier
    user ||= find_by_email identifier
    return false if user.nil?
    user.authenticate(password)
  end
end
