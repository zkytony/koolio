'''
Notifications
action (notifiable_type)

FollowedByUser (User): user followed another user
ShareDeck (DeckUserAssociation): user shared a deck to another user as editor or viewer
RecommendTo (Recommendation): user recommended a card to another user
FavoriteDeck (Favorite): user favorited a deck
LikeCard (LikeCard): user liked a card
'''
class Notification < ActiveRecord::Base
  validates_presence_of :user_id, :action, :notifier_type, :notifier_id

  belongs_to :user
  belongs_to :notifier, polymorphic: true
end
