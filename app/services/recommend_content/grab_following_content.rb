class RecommendContent
  class GrabFollowingContent
    # Given user, number of cards, and number of decks
    # return a content array containing the required
    # number of cards & decks, retrieved from the users
    # that the given user is following.
    #
    # When there are not enough number of cards / decks
    # in from the users that the given user follows, then
    # return the contents with the max possible size
    #
    # Currently only grab cards
    def self.call(user, n_card, n_deck, more, card_ids)
      contents = []
      card_providers = user.following.sort_by{ rand }.slice(0, n_card)
      #deck_providers = user.following.sort_by{ rand }.slice(0, n_deck)

      if more
        # avoid duplicates
        card_providers.each do |provider|
          contents |= provider.cards.where("cards.id NOT IN (?)", card_ids).sort_by(&:created_at).reverse.first(6).shuffle
        end
        # deck_providers.each do |provider|
        #   contents << provider.decks.offset(rand(provider.cards.count)).where("cards.id NOT IN (?)", card_ids)
        # end
      else
        card_providers.each do |provider|
          contents |= provider.cards.sort_by(&:created_at).first(6).shuffle
        end

        # deck_providers.each do |provider|
        #   contents << provider.decks.offset(rand(provider.cards.count)).first
        # end
      end
      contents
    end
  end
end
