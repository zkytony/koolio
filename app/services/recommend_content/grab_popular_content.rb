class RecommendContent
  class GrabPopularContent
    # For now: Popular content are cards with the highest
    # number of likes. 
    def self.call(user, n_card, more, card_ids)
      contents = []
      if more
        contents = Card.where("cards.id NOT IN (?)", card_ids).sort_by(&:likes).slice(0, n_card)
      else
        contents = Card.all.sort_by(&:likes).reverse.slice(0, n_card)
      end
      contents
    end
  end
end
