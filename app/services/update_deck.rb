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
                tags)
    if deck.editable_by? user
      deck.update_attributes(deck_params)
      # remove all tags
      deck.remove_all_tags
      deck.update_attributes({:tags_names => nil})
      # add tags
      tag_params = []
      tags.each do |tag_name|
        tag_params << {name: tag_name}
      end
      deck.add_tags(tag_params)

      # share visitors
      shared_visitors.each do |person|
        if !deck.viewable_by? person
          deck.share_to(person, "Viewer")
        end
      end

      # share editors
      shared_editors.each do |person|
        if !deck.editable_by? person
          deck.share_to(person, "Editor")
        end
      end

      deck
    else
      nil
    end
  end
end
