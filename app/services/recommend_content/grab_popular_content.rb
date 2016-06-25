class RecommendContent
  class GrabPopularContent
    # For now: Popular content are cards with the highest
    # number of likes.
    #
    # Currently only grab cards
    def self.call(user, n_card, more, card_ids, category_id="all", subdomain)
      contents = []
      if more  
        contents = Card.where(subdomain: subdomain).where("cards.id NOT IN (?)", card_ids)
      else
        contents = Card.where(subdomain: subdomain)
      end
      if category_id.downcase != "all"
        contents.to_a.delete_if do |content|
          if content.is_a? Card
            if content.deck.category.nil? || content.deck.category.id != category_id.to_i
              true
            else
              false
            end
          else
            false
          end
        end  # end delete_if
      end
      contents.sort_by(&:likes).slice(0, n_card).shuffle
    end
  end
end
