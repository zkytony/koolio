class GrabProfileDecks
  # Given a user, grab certain number of decks made
  # by the user. Currently the decks are ordered
  # by created time, from youngest to oldest.
  def self.call(user)
    n_decks = 7
    decks = user.decks.sort_by(&:created_at).reverse.slice(0, n_decks)
  end
end
