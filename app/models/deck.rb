class Deck < ActiveRecord::Base
  validates :user_id, presence: true
  validates :title, presence: true,
                    length: { maximum: 175 }

  belongs_to :user
  has_many :cards,   dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def build_card(card_params, user)
    card = self.cards.build(card_params)
    card.user = user
    card
  end
end

