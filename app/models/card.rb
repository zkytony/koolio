class Card < ActiveRecord::Base
  validates :deck_id, presence: true
  validates :user_id, presence: true
  validates_inclusion_of :hide, :in => [true, false]
  
  belongs_to :deck
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :users_with_like, class_name: "LikeCard", dependent: :destroy
  has_many :liked_users, through: :users_with_like, source: :user

  has_many :recommendations, as: :recommendable, dependent: :destroy
  has_many :activities, as: :trackable, dependent: :destroy

  def viewable_by?(user)
    self.creator?(user) || (!self.hide && self.deck.viewable_by?(user))
  end

  def creator
    self.user
  end

  def creator?(user)
    self.creator.id == user.id
  end

  def is_recommended_by?(user)
    return user.recommendings_of_cards.include?(self)
  end

  def is_recommended_to?(user)
    return user.recommended_cards.include?(self)
  end
end
