'''
Activities
action (trackable_type):

CreateDeck (Deck): user created a deck
UpdateDeck (Deck): user updated deck info (title, description)
FavoriteDeck (Deck): user favorited a deck
CreateCard (Card): user created a card
UpdateCard (Card): user updated a card
LikeCard (Card): user liked a card
CreateComment (Comment): user made a comment
FollowUser (User): user followed another user
'''
class Activity < ActiveRecord::Base
  validates_presence_of :user_id, :action, :trackable_type, :trackable_id

  belongs_to :user
  belongs_to :trackable, polymorphic: true
end
