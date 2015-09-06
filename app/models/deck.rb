class Deck < ActiveRecord::Base
  validates :user_id, presence: true
  validates :title, presence: true,
                    length: { maximum: 175 }
  validates_inclusion_of :open, :in => [true, false]

  belongs_to :user
  has_many :cards,   dependent: :destroy

  has_many :users_with_favor, class_name: "Favorite", dependent: :destroy
  has_many :favoring_users, through: :users_with_favor, source: :user

  has_and_belongs_to_many :tags, dependent: :destroy

  has_many :deck_user_associations, dependent: :destroy
  has_many :deck_editor_associations, dependent: :destroy
  has_many :deck_viewer_associations, dependent: :destroy
  has_many :shared_users, through: :deck_user_associations, source: :user
  has_many :editors, through: :deck_editor_associations, source: :user  # STI
  has_many :normal_viewers, through: :deck_viewer_associations, source: :user # STI; used when deck is not open

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

  def creator
    self.user
  end

  def share_to(user, role="")
    case role.upcase
    when "EDITOR"
      self.deck_editor_associations.create(user_id: user.id)
    when "VIEWER"
      self.deck_viewer_associations.create(user_id: user.id)
    else
      false
    end
  end

  def change_share_role(user, role="")
    deck_user_assoc = self.deck_user_associations.find_by(user_id: user.id)
    case role.upcase
    when "EDITOR"
      deck_user_assoc.type = "DeckEditorAssociation"
      deck_user_assoc.save!
    when "VIEWER"
      deck_user_assoc.type = "DeckViewerAssociation"
      deck_user_assoc.save!
    else
      false
    end
  end

  def unshare(user)
    if user.id != self.creator.id
      self.deck_user_associations.find_by(user_id: user.id).destroy
    end
    false
  end

  def is_editor?(user)
    return self.editors.include?(user)
  end

  def viewable_by?(user)
    return self.open || self.shared_users.include?(user)
  end
end

