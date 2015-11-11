class RecommendContent
  # Given a user, return an array containing distinctive
  # recommended contents for this user. Basically for now,
  # it grabs some of the cards or decks produced by users
  # followed by the given user, and grab some of the cards
  # from the decks that this user favorites, and grab some
  # of the popular cards or decks.
  def self.call(user)
    n_card = 7
    n_deck = 5
    
    # GrabPopularContent is not implemented
    contents = GrabFollowingContent.call(user, n_card, n_deck)
    contents |= GrabFavoriteContent.call(user, n_card) # take the union here
    contents |= GrabSelfLatestContent.call(user, 30)
    contents
  end
end
