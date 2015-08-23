class User < ActiveRecord::Base
  include ActiveModel::SecurePassword

  has_many :decks,    dependent: :destroy
  has_many :cards,    dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy   # Follow others
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy  # Being followed by others
  has_many :followers, through: :passive_relationships
  has_many :favor_of_decks, class_name: "Favorite", foreign_key: "user_id", dependent: :destroy
  has_many :favorite_decks, through: :favor_of_decks, source: :deck

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
    self.active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    self.active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    self.following.include?(other_user)
  end

  def self.find_by_email(email)
    User.find_by email: email
  end

  def self.find_by_username(username)
    User.find_by username: username
  end

  def self.authenticate(identifier, password)
    user = find_by_username identifier
    user ||= find_by_email identifier
    return false if user.nil?
    user.authenticate(password)
  end

  def owns_deck?(deck)
    self.decks.include?(deck)
  end

  def owns_card?(card)
    self.cards.include?(card)
  end

  def favor_deck(deck)
    self.favor_of_decks.create(deck_id: deck.id)
  end

  def unfavor_deck(deck)
    self.favor_of_decks.find_by(deck_id: deck.id).destroy
  end

  def favoring_deck?(deck)
    self.favorite_decks.include?(deck)
  end
end
