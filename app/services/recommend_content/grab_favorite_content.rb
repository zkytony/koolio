class RecommendContent
  class GrabFavoriteContent
    # For now: User can only favorite a deck. Therefore,
    # this method returns contents of type 'card' in some
    # of the decks that the user favorites, with size equal 
    # to the given number of cards
    def self.call(user, n_card)
      contents = []
      
      card_providers = user.favorites.sort_by{ rand }.slice(0, n_card)
      
      # each provider is a deck
      card_providers.each do |provider|
        contents.provider.cards.offset(rand(provider.cards.count)).first
      end
    end
  end
end
