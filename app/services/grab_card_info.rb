class GrabCardInfo
  # Given a card and a user, return a JSON string
  # containing number of likes, comments, and all
  # comments (assuming not too much. May need to change
  # this later), and deck title, deck id, deck description,
  # number of favorites of the deck, other cards in the deck,
  # author title, author id.
  #
  # Comments and cards are sorted by number of likes.
  #
  # If the user does not have permission to view the card,
  # the resulting JSON string will be empty.
  def self.call(card, user)
    if card.viewable_by?(user)
      n_comments = 10
      n_cards = 5

      deck = card.deck
      comments = card.comments.take(n_comments)  # like feature for comments is not available right now
      cards = deck.cards.order(:like).take(n_cards)
      # use hash and convert it to JSON
      # PROBLEM: BETTER ADD A LIKE COLUMN TO cards AND comments TO SPPED THINGS UP
      # OR IS IT BETTER TO JUST RETRIEVE EVERYTHING WHEN GRABBING THE RECOMMENDED CONTENT?
      # OR A COMBINATION OF AJAX AND RETRIEVE INITIALLY?
    else
    end
  end
end
