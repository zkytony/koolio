class CreateCard
  def self.call(card_params, user, deck_id, subdomain="www")
    # if the provided deck_id is nil, then
    # put this card into user's default deck
    if deck_id
      @deck = Deck.find(deck_id)
    else
      default_deck = "default"
      if subdomain != "www"
        default_deck = "default #{subdomain}.koolio"
      end
      @deck = user.decks.find_by(title: default_deck)
    end

    @card = @deck.build_card(card_params, user)
    @card.save!
  end
end


