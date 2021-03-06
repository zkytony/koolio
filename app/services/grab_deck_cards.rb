class GrabDeckCards
  # Grab cards in a deck
  def self.call(deck, more, all, card_ids)
    n_cards = 7
    cards = []
    if all
      cards = deck.cards.sort_by(&:created_at).reverse
    else
      if more
        cards = deck.cards.where("cards.id NOT IN (?)", card_ids).sort_by(&:created_at).reverse.slice(0, n_cards)
      else
        cards = deck.cards.sort_by(&:created_at).reverse.slice(0, n_cards)
      end
      cards
    end
  end
end
