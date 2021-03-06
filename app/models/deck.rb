class Deck < ActiveRecord::Base
  include PgSearch

  VALID_SUBDOMAIN_REGEX = /\A[a-zA-Z0-9]+\Z/i
  validates :user_id, presence: true
  validates :title, presence: true,
                    length: { maximum: 175 }
  validates_inclusion_of :open, :in => [true, false]

  validates :subdomain,  presence: true,
                         length: { maximum: 255, minimum: 1 },
                         format: { with: VALID_SUBDOMAIN_REGEX }

  belongs_to :user
  has_many :cards, dependent: :destroy

  has_many :users_with_favor, class_name: "Favorite", dependent: :destroy
  has_many :favoring_users, through: :users_with_favor, source: :user

  has_and_belongs_to_many :tags, dependent: :destroy
  
  # Note: this is a sophisticated way to express the one-to-many relation between decks and categories.
  # A deck has one category, and one category can be used for many decks. The simpler way would be
  # to get rid of the Categorization model, and use has_many :decks in the Category model. But doing
  # so requires a new migration and schema change which I was relunctant to do.
  has_one :categorization
  has_one :category, through: :categorization

  has_many :deck_user_associations, dependent: :destroy
  has_many :deck_editor_associations, dependent: :destroy
  has_many :deck_viewer_associations, dependent: :destroy
  has_many :shared_users, through: :deck_user_associations, source: :user
  has_many :editors, through: :deck_editor_associations, source: :user  # STI
  has_many :normal_viewers, through: :deck_viewer_associations, source: :user # STI; used when deck is not open

  has_many :recommendations, as: :recommendable, dependent: :destroy
  has_many :activities, as: :trackable, dependent: :destroy

  multisearchable :against => [:title, :description, :tags_names]

  def build_card(card_params, user)
    if self.editable_by?(user)
      card = self.cards.build(card_params)
      card.user = user
      card.subdomain = self.subdomain
      card
    end
  end
  
  # will not create duplicate tags
  # If the tag already exists, return nil; otherwise
  # return the added tag.
  #
  # This method does not update the pg_search document.
  # Use add_tags to do update, because it is more efficient
  def add_tag(tag_params)
    tag = Tag.find_or_create_by(tag_params)
    if !self.tags.include? tag
      self.tags << tag
      tags_names = self.tags_names
      if tags_names
        self.tags_names = self.tags_names + " " + tag.name
      else
        self.tags_names = tag.name
      end
      self.save!
      tag
    else
      nil
    end
  end

  # adds all given tags to this deck if not already
  # The given tags is an array of tag_params, which
  # has one attribute name
  def add_tags(tags)
    if !tags.empty?
      tags.each do |tag_param|
        self.add_tag(tag_param)
      end
      # update pg search document
      self.update_pg_search_document
    end
  end

  def remove_tag(tag)
    self.tags.delete(tag)
  end

  def remove_all_tags
    self.tags.delete_all
  end

  # returns a string of tags separated by spaces
  def tags_by_name
    result = ''
    self.tags.each_with_index do |tag, index|
      result += tag.name
      if index != self.tags.size - 1
        result += " "
      end
    end
    result
  end

  # returns an array of string with tag names
  def all_tags
    result = []
    self.tags.each_with_index do |tag, index|
      result << tag.name
    end
    result
  end

  def creator
    self.user
  end

  def creator?(user)
    self.creator.id == user.id
  end

  # Share deck to given user
  #
  # This method prevents duplicates by checking if the
  # given user has already have the rights for the role.
  #
  # If a deck is "open", the deck is always viewable by
  # the given user. Therefore this method will not create
  # the additional viewer association between the user and
  # the deck. 
  #
  # no_assoc - should be true if it is certain that the deck has 
  #            NOT been shared to the user. False otherwise. 
  #            (default: false)
  #
  # Return false if:
  # - the given role is neither "EDITOR" nor "VIEWER",
  #   case insensitive. OR
  # - the user has already been shared with the role
  def share_to(user, role="", no_assoc = false)
    case role.upcase
    when "EDITOR"
      if no_assoc or !self.editable_by? user
        self.deck_editor_associations.create(user_id: user.id)
      else
        return false
      end
    when "VIEWER"
      if no_assoc or !self.viewable_by? user
        self.deck_viewer_associations.create(user_id: user.id)
      else
        return false
      end
    else
      false
    end
  end

  # Change the type of role of a user to a new given role
  #
  # If the user is the creator of the deck, his role cannot
  # be changed. So return false.
  #
  # If the deck has not been shared to the user, then this
  # method will perform the sharing. Namely, after this
  # method executes, if the role argument is valid, then
  # this deck will certainly be shared to the user with the
  # given role
  def change_share_role(user, role="")
    if self.creator? user
      return false
    end

    deck_user_assoc = self.deck_user_associations.find_by(user_id: user.id)
    if deck_user_assoc
      # this deck is shared to the given user
      case role.upcase
      when "EDITOR"
        deck_user_assoc.type = "DeckEditorAssociation"
        deck_user_assoc.save!
      when "VIEWER"
        deck_user_assoc.type = "DeckViewerAssociation"
        deck_user_assoc.save!
      else
        return false
      end
    else
      # this deck has not been shared to the given user.
      # share it now
      self.share_to(user, role, true)
    end
  end

  def unshare(user)
    if !self.creator?(user) 
      self.deck_user_associations.find_by(user_id: user.id).destroy
      true
    end
    false
  end

  def editable_by?(user)
    user && user.activated? && self.editors.include?(user)
  end

  def viewable_by?(user)
    return self.open || self.shared_users.include?(user)
  end

  # can this deck be explored by anybody? No user is 
  # supplied.
  def explorable?
    return self.open
  end
  alias_method :is_open?, :explorable?

  def is_recommended_by?(user)
    return user.recommendings_of_decks.include?(self)
  end

  def is_recommended_to?(user)
    return user.recommended_decks.include?(self)
  end
end

