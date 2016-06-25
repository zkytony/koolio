class UpdateDeck
  # Update given deck with given arguments, if
  # the given user has the permission
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
                deck,
                user,
                shared_editors, 
                shared_visitors,
                category_id,
                tags)
    if deck.editable_by? user
      deck.update_attributes(deck_params)
      # remove all tags
      # deck.remove_all_tags
      # deck.update_attributes({:tags_names => nil})
      # # add tags
      # tag_params = []
      # tags.each do |tag_name|
      #   tag_params << {name: tag_name}
      # end
      # deck.add_tags(tag_params)
      
      if category_id
        deck.category = Category.find(category_id)
        deck.save!
      end

      # Sharing is only intended for mutually followed users
      # to avoid unwanted shares

      # If editor and visitor sets both have a user, remove it
      # from visitor's set.
      shared_visitors.delete_if do |sv|
        if shared_editors.include? sv
          true
        else
          false
        end
      end

      mutuals = user.mutual_follows

      # First destroy all existing sharing
      deck.deck_user_associations.destroy_all
      # Add the user back as the editor
      deck.deck_editor_associations.create(user_id: user.id)

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
