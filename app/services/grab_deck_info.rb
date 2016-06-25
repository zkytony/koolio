class GrabDeckInfo
  # grabs deck info
  # return a hash object with attributes as follows:
  # deck (a Deck object), author (a User object),
  # tags (array of strings), shared_editors (an array
  # of User objects, including the author), shared_viewers 
  # (an array of User objects).
  def self.call(deck, user)
    if deck.viewable_by? user
      info = {
        deck: deck,
        author: deck.creator,
        shared_editors: deck.editors - [deck.creator],
        shared_visitors: deck.normal_viewers,
        category: deck.category
      }
    end
  end
end
