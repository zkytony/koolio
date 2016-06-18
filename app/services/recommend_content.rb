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
  #
  # subdomain is used to restrict which subset of content to
  # grab from.
  def self.call(user, more, card_ids, context, subdomain="www")
    n_card = 30
    n_deck = 8
    
    contents = []
    if context == :explore
      contents |= GrabPopularContent.call(user, n_card, more, card_ids, subdomain) # take the union here
      contents
    elsif context == :home
      contents |= GrabFollowingContent.call(user, n_card, n_deck, more, card_ids, subdomain)
      if !more
        contents |= GrabSelfLatestContent.call(user, 30, subdomain)
      end
      contents |= GrabFavoriteContent.call(user, n_card, more, card_ids, subdomain)
      contents
    else
      nil
    end
  end
end
