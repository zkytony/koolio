class CreateDeck
  # Create a deck with the given arguments
  # Add given tags to it, and share the deck
  # to given list of shared_ROLE users
  #
  # shared_editors - a set of users that will be
  #                  shared to as editors
  # shared_visitors - a set of users that will be
  #                   shared to as viewers
  # tags - a set of tag names
  #
  # preconditions:
  # - ???? necessary ??? if shared_editors contain a certain string
  #   representing a user, then shared_visitor
  #   should not contain that user.
  def self.call(deck_params, 
                user,
                subdomain,
                open, 
                shared_editors, 
                shared_visitors,
                category_id,
                tags)
    deck_params[:open] = open
    deck_params[:subdomain] = subdomain
    deck = user.create_deck(deck_params)
    if deck
      # add tags
      # tags.each do |tag_name|
      #   deck.add_tag({name: tag_name})
      # end

      deck.category = Category.find(category_id)
      deck.save!

      # Sharing is only intended for mutually followed users
      # to avoid unwanted shares

      mutuals = user.mutual_follows

      # share visitors
      shared_visitors.each do |person|
        if mutuals.include?(person) && !deck.viewable_by?(person)
          deck.share_to(person, "Viewer")
        end
      end

      # share editors
      shared_editors.each do |person|
        if mutuals.include?(person) && !deck.editable_by?(person)
          deck.share_to(person, "Editor")
        end
      end
      
      deck
    else
      nil
    end
  end
end
