class GrabProfileDecks
  # Given a user, grab certain number of decks made
  # by the user. Currently the decks are ordered
  # by created time, from youngest to oldest.
  #
  # preconditions:
  # - if more is true, then deck_ids cannot be nil
  # - if more is false, then deck_ids must be nil
  def self.call(user, more, deck_ids)
    n_decks = 9
    if more
      decks = user.decks.where("decks.id NOT IN (?)", deck_ids).sort_by(&:created_at).reverse.slice(0, n_decks)
    else
      decks = user.decks.sort_by(&:created_at).reverse.slice(0, n_decks)
    end
    decks
  end
end
