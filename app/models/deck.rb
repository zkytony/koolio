class Deck < ActiveRecord::Base
  validates :user_id, presence: true
  validates :title, presence: true,
                    length: { maximum: 175 }

  belongs_to :user
  has_many :cards,   dependent: :destroy
  has_many :favoring_users, class_name: "Favorite", dependent: :destroy
  has_and_belongs_to_many :tags

  def build_card(card_params, user)
    card = self.cards.build(card_params)
    card.user = user
    card
  end

  def add_tag(tag_params)
    self.tags.create(tag_params)
  end
end

