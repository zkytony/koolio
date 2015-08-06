class User < ActiveRecord::Base
  include ActiveModel::SecurePassword

  has_many :decks,    dependent: :destroy
  has_many :cards,    dependent: :destroy
  has_many :active_relationships, class_name: "Following", foreign_key: "followee_id", dependent: :destroy   # Follow others
  has_many :following, through: :active_relationships, source: :followee
  has_many :passive_relationships, class_name: "Following", foreign_key: "follower_id", dependent: :destroy  # Being followed by others
  has_many :followers, through: :passive_relationships

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username,  presence: true,
                        uniqueness: true
  validates :email,     presence: true,
                        uniqueness: true,
                        format: { with: VALID_EMAIL_REGEX },
                        length: { maximum: 255 }
  validates :password,  presence: true,
                        length: { minimum: 6 }
  
  has_secure_password   # Enforces validation on the virtual password & password_confirmation attributes

  def follow(other_user)
    active_relationships.create(followee_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followee_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end
end
