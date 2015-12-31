class Search
  # right now only return maximum of 20 cards
  def self.call(str, user)
    # find cards with string matching given;
    # find decks with description/title matching the given string,
    #   and return its cards
    filtered_docs = []
    PgSearch.multisearch(str).limit(20).find_each do |document|
      if document.searchable.viewable_by? user
        filtered_docs << document
      end
    end
    filtered_docs
  end
end
