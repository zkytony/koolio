class CreateCard
  def self.call(card_params, user, deck_id, subdomain="www")
    # if the provided deck_id is nil, then
    # put this card into user's default deck
    if deck_id
      @deck = Deck.find(deck_id)
    else
      @deck = user.decks.find_by(title: "default")
    end

    @card = @deck.build_card(card_params, user)
    @card.subdomain = subdomain
    @card.save!
  end
end


