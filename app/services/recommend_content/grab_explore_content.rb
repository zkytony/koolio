class RecommendContent
  class GrabExploreContent
    # For now: Popular content are cards with the highest
    # number of likes.
    #
    # Currently only grab cards
    #
    # user is the user that wants to explore
    def self.call(user, n_content, more, content_ids, category_id="all", subdomain, sort, type)
      if sort.nil?
        sort = "time"
      end
      if type.nil?
        type = "card"
      end

      contents = []
      if more
        if type == "card"
          contents = Card.where(subdomain: subdomain).where("cards.id NOT IN (?)", content_ids)
        else
          contents = Deck.where(subdomain: subdomain).where("decks.id NOT IN (?)", content_ids)
        end
      else
        if type == "card"
          contents = Card.where(subdomain: subdomain)
        else
          contents = Deck.where(subdomain: subdomain)
        end
      end

      # Filter contents by category_id
      # TODO: improve this by using a single SQL query if possible.
      if category_id.downcase != "all"
        contents.to_a.delete_if do |content|
          if content.is_a? Card
            if content.deck.category.nil? || content.deck.category.id != category_id.to_i
              true
            else
              false
            end
          else
            if content.category.nil? || content.category.id != category_id.to_i
              true
            else
              false
            end
          end
        end  # end delete_if
      end
      # Filter decks if they don't have any cards
      contents.to_a.delete_if do |content|
        if content.is_a? Deck
          if content.cards.count == 0
            true
          else
            false
          end
        end
      end
      
      # sort
      if sort == "time"
        contents.sort_by(&:created_at).reverse.slice(0, n_content)
      else
        if type == "card"
          contents.sort_by(&:likes).slice(0, n_content).reverse
        else
          contents.sort_by(&:favorites_count).slice(0, n_content).reverse
        end
      end
    end
  end
end
