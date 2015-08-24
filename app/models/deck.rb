class Deck < ActiveRecord::Base
  validates :user_id, presence: true
  validates :title, presence: true,
                    length: { maximum: 175 }

  belongs_to :user
  has_many :cards,   dependent: :destroy
  has_many :users_with_favor, class_name: "Favorite", dependent: :destroy
  has_many :favoring_users, through: :users_with_favor, source: :user
  has_and_belongs_to_many :tags, dependent: :destroy

  def build_card(card_params, user)
    card = self.cards.build(card_params)
    card.user = user
    card
  end

  def add_tag(tag_params)
    tag = Tag.find_or_create_by(tag_params)
    self.tags << tag
    tag
  end

  def remove_tag(tag)
    self.tags.delete(tag)
  end

  def remove_all_tags
    self.tags.delete_all
  end

  # returns a string of tags separated by comma
  def tags_by_name
    result = ''
    self.tags.each_with_index do |tag, index|
      result += tag.name
      if index != self.tags.size - 1
        result += ","
      end
    end
    result
  end
end

