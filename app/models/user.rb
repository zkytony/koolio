class User < ActiveRecord::Base
  include ActiveModel::SecurePassword

  has_many :decks,    dependent: :destroy
  has_many :cards,    dependent: :destroy
  has_many :comments, dependent: :destroy

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
