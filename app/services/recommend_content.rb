class RecommendContent
  # Given a user, return an array containing distinctive
  # recommended contents for this user. Basically for now,
  # it grabs some of the cards or decks produced by users
  # followed by the given user, and grab some of the cards
  # from the decks that this user favorites, and grab some
  # of the popular cards or decks.
  #
  # context is :home or :explore; :home will not grab popular
  # cards, and :explore will. If context is neither of these
  # two values, return nil.
  def self.call(user, more, card_ids, context)
    n_card = 15
    n_deck = 5
    
    contents = []
    if context == :explore
      contents |= GrabPopularContent.call(user, n_card, more, card_ids) # take the union here
      contents
    elsif context == :home
      contents |= GrabFollowingContent.call(user, n_card, n_deck, more, card_ids)
      if !more
        contents |= GrabSelfLatestContent.call(user, 30)
      end
      contents |= GrabFavoriteContent.call(user, n_card, more, card_ids)
      contents
    else
      nil
    end
  end
end
