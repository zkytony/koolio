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
  #
  # category_id is the id for the category of the deck. Or,
  # it can be string "All"
  def self.call(user, more, content_ids, context, category_id="all", subdomain="www", sort="time", type="card")
    n_card = 4
    n_deck = 3
    
    contents = []
    if context == :explore
      # contents |= GrabPopularContent.call(user, n_card, more, content_ids, category_id, subdomain, sort, type) # take the union here
      contents |= GrabExploreContent.call(user, n_card, more, content_ids, category_id, subdomain, sort, type) # take the union here
      contents
    elsif context == :home
      contents |= GrabFollowingContent.call(user, n_card, n_deck, more, content_ids, subdomain)
      if !more
        contents |= GrabSelfLatestContent.call(user, n_card, subdomain)
      end
      contents |= GrabFavoriteContent.call(user, n_card, more, content_ids, subdomain)
      contents.sort_by {|a| a.created_at }.reverse
    else
      nil
    end
  end
end
