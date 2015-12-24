class RecommendContent
  # Given a user, return an array containing distinctive
  # recommended contents for this user. Basically for now,
  # it grabs some of the cards or decks produced by users
  # followed by the given user, and grab some of the cards
  # from the decks that this user favorites, and grab some
  # of the popular cards or decks.
  def self.call(user, more, card_ids)
    n_card = 7
    n_deck = 5
    
    # GrabPopularContent is not implemented
    contents = []
    if !more
      contents |= GrabSelfLatestContent.call(user, 120)
    end
    contents |= GrabFollowingContent.call(user, n_card, n_deck, more, card_ids)
    contents |= GrabPopularContent.call(user, n_card, more, card_ids) # take the union here
    contents |= GrabFavoriteContent.call(user, n_card, more, card_ids)
    contents
  end
end
