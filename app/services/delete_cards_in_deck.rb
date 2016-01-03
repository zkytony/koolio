class DeleteCardsInDeck
  def self.call(deck, card_ids)
    if !card_ids.empty?
      # destroy all may be time consuming, but now
      # intended to delete all associated objects
      deck.cards.where(:id => card_ids).destroy_all
    end
  end
end
