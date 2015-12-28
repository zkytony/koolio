class User < ActiveRecord::Base
  include ActiveModel::SecurePassword

  has_many :decks,    dependent: :destroy
  has_many :cards,    dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy   # Follow others
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy  # Being followed by others
  has_many :followers, through: :passive_relationships
  has_many :favor_of_decks, class_name: "Favorite", dependent: :destroy
  has_many :favorite_decks, through: :favor_of_decks, source: :deck
  has_many :like_of_cards, class_name: "LikeCard", dependent: :destroy
  has_many :liked_cards, through: :like_of_cards, source: :card
  has_many :like_of_comments, class_name: "LikeComment", dependent: :destroy
  has_many :liked_comments, through: :like_of_comments, source: :comment

  has_many :deck_user_associations, dependent: :destroy
  has_many :deck_editor_associations, dependent: :destroy
  has_many :deck_viewer_associations, dependent: :destroy
  has_many :editable_decks, through: :deck_editor_associations, source: :deck
  has_many :decks_shared_for_view, through: :deck_viewer_associations, source: :deck

  has_many :active_recommendations, class_name: "Recommendation", foreign_key: "from_user_id", dependent: :destroy
  has_many :recommendings_of_cards, through: :active_recommendations, source: :recommendable, source_type: "Card"
  has_many :recommendings_of_decks, through: :active_recommendations, source: :recommendable, source_type: "Deck"
  has_many :passive_recommendations, class_name: "Recommendation", foreign_key: "to_user_id", dependent: :destroy
  has_many :recommended_cards, through: :passive_recommendations, source: :recommendable, source_type: "Card"
  has_many :recommended_decks, through: :passive_recommendations, source: :recommendable, source_type: "Deck"

  has_many :activities, as: :trackable, dependent: :destroy
  has_many :activities, dependent: :destroy

  has_many :notifications, as: :notifier, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :uploaded_files

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username,  presence: true,
                        uniqueness: true,
                        length: { maximum: 25 }
  validates :email,     presence: true,
                        uniqueness: true,
                        format: { with: VALID_EMAIL_REGEX },
                        length: { maximum: 255 }
  validates :password,  presence: true,
                        length: { minimum: 6 }, on: :create
  validates :password,  length: { minimum: 6 }, on: :update, allow_blank: true
  
  has_secure_password   # Enforces validation on the virtual password & password_confirmation attributes

  # This function creates the deck, and adds the user as editor to the deck_user_associations
  # Use this instead of self.decks.create alone
  def create_deck(deck_params)
    deck = self.decks.create!(deck_params)
    deck.deck_editor_associations.create(user_id: self.id)
    deck
  end

  def follow(other_user)
    self.active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    self.active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    self.following.include?(other_user)
  end

  # Do you and me follow each other?
  def following_mutually?(other_user)
    self.following.include?(other_user) && other_user.following.include?(self)
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

  def like_card(card)
    if self.like_of_cards.create(card_id: card.id)
      # increment count in the card's likes column
      card.increment!(:likes)
    end
  end

  def unlike_card(card)
    like = self.like_of_cards.find_by(card_id: card.id)
    if like
      like.destroy
      # decrement count in the card's likes column
      card.decrement!(:likes)
    end
  end

  def liked_card?(card)
    self.liked_cards.include?(card)
  end

  # Create (save) a comment given a card and a message
  def comment(card, message)
    self.comments.create(card_id: card.id, content: message)
  end

  # Only builds the comment; does not save it
  def build_comment(comment_params)
    self.comments.build(comment_params)
  end

  def like_comment(comment)
    if self.like_of_comments.create(comment_id: comment.id)
      # increment count in the card's likes column
      comment.increment!(:likes)
    end
  end

  def unlike_comment(comment)
    like = self.like_of_comments.find_by(comment_id: comment.id)
    if like
      like.destroy
      # decrement count in the card's likes column
      comment.decrement!(:likes)
    end
  end

  def liked_comment?(comment)
    self.liked_comments.include?(comment)
  end

  def turndown_deck_share(deck)
    if deck.creator.id != self.id
      self.deck_user_associations.find_by(deck_id: deck.id).destroy
    end
    false
  end
  
  # recommend a recommendable model to the other user
  def recommend_to(other_user, recommendable)
    self.active_recommendations.create(to_user_id: other_user.id, recommendable: recommendable)
  end

  def cancel_recommendation(other_user, recommendable)
    self.active_recommendations.find_by(to_user_id: other_user.id, recommendable: recommendable).destroy
  end

  def turndown_recommendation(other_user, recommendable)
    self.passive_recommendations.find_by(from_user_id: other_user.id, recommendable: recommendable).destroy
  end

  # get full name. If neither first name nor last name is set,
  # then return nil
  def full_name
    if !self.first_name and !self.last_name
      return nil
    else
      "#{self.first_name} #{self.last_name}"
    end
  end
  
  # return a hash object with "front", and "back" as attributes,
  # each of which has value that is the url to the thumbnail
  # version of the avatar on that side
  #
  # assume side is either "front" or "back"
  def my_avatar!(side)
    if self.avatar
      file = JSON.parse(self.avatar)[side]
      "#{file['host']}/#{file['store_dir']}/thumb_#{file['file_name']}"
    else
      "/assets/default-profile.svg"
    end
  end

  def avatar_json(side)
    if self.avatar
      JSON.parse(self.avatar)[side]
    end
  end
end
