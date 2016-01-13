class RecommendContent
  class GrabPopularContent
    # For now: Popular content are cards with the highest
    # number of likes.
    #
    # Currently only grab cards
    def self.call(user, n_card, more, card_ids)
      contents = []
      if more
        contents = Card.where("cards.id NOT IN (?)", card_ids).sort_by(&:likes).slice(0, n_card).shuffle
      else
        contents = Card.all.sort_by(&:likes).reverse.slice(0, n_card).shuffle
      end
      contents
    end
  end
end
