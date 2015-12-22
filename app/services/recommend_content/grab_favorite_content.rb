class RecommendContent
  class GrabFavoriteContent
    # For now: User can only favorite a deck. Therefore,
    # this method returns contents of type 'card' in some
    # of the decks that the user favorites, with size equal 
    # to the given number of cards
    def self.call(user, n_card, more, card_ids)
      contents = []
      
      card_providers = user.favorite_decks.sort_by{ rand }.slice(0, n_card)
      
      if more
        card_providers.each do |provider|
          contents << provider.cards.offset(rand(provider.cards.count)).where("cards.id NOT IN (?)", card_ids)
        end
      else
        # each provider is a deck
        card_providers.each do |provider|
          contents << provider.cards.offset(rand(provider.cards.count)).first
        end
      end
      contents
    end
  end
end
