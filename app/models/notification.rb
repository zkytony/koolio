'''
Notifications
action (notifiable_type)

FollowedByUser (Relationship): user followed another user
ShareDeck (DeckUserAssociation): user shared a deck to another user as editor or viewer
RecommendTo (Recommendation): user recommended a card to another user
FavoriteDeck (Favorite): user favorited a deck
LikeCard (LikeCard): user liked a card
LikeComment (LikeComment): user liked a comment
MakeComment (Comment): user made a comment
'''
class Notification < ActiveRecord::Base
  validates_presence_of :user_id, :action, :notifier_type, :notifier_id

  belongs_to :user
  belongs_to :notifier, polymorphic: true

  # A message representing this notification. The message is
  # a json string that looks like this:
  # { 
  #   who: user id of the user that triggered the notification
  #   action: "action string", 
  #   target_type: "target class name", 
  #   target_id: string id of the target object
  #   when: "time ago" }
  def message
    self.notifier.message
  end
end
