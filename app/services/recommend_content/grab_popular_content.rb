class RecommendContent
  class GrabPopularContent
    # For now: Popular content are cards with the highest
    # number of likes. 
    def self.call(user, n_card)      
      contents = Card.all.sort_by(&:likes).slice(0, n_card)
    end
  end
end
