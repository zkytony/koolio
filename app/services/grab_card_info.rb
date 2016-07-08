class GrabCardInfo
  # Given a card and a user, return a JSON string
  # containing number of likes, comments, and all
  # comments (assuming not too much. May need to change
  # this later), and deck title, deck id, deck description,
  # number of favorites of the deck, other cards in the deck,
  # author title, author id.
  #
  # Since a deck can be shared to others, the author in the
  # info here is the author of the card.
  #
  # Comments and cards are sorted by number of likes.
  #
  # If the user does not have permission to view the card,
  # the resulting JSON string will be empty.
  def self.call(card, user)
    if !user.nil?
      if card.viewable_by?(user)
        info = grab_info(card)
        info[:liked_card] = user.liked_card?(card)
        info
      else
        nil
      end
    else
      if card.explorable?
        info = grab_info(card)
        info[:liked_card] = nil
        info
      else
        nil
      end
    end
  end

  private

  def self.grab_info(card)
    n_comments = 10
    n_cards = 5

    deck = card.deck
    author = card.user
    comments = card.comments
    cards = deck.cards.order(:likes).reverse_order.take(n_cards)
    # use hash and convert it to JSON
    info = {
      card_id: card.id,
      author: author,
      deck: deck,
      n_likes: card.likes, 
      n_comments: comments.count,
      other_cards: cards, 
      comments: comments.order(:likes).reverse_order.take(n_comments)
    }
    info
  end
end
