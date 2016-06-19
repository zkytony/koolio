class Search
  # right now only return maximum of 20 cards
  def self.call(str, user, subdomain)
    # find cards with string matching given;
    # find decks with description/title matching the given string,
    #   and return its cards
    filtered_docs = []
    PgSearch.multisearch(str).limit(20).find_each do |document|
      if !user.nil?
        if document.searchable.viewable_by?(user) and document.searchable.subdomain == subdomain
          filtered_docs << document
        end
      else
        if document.searchable.explorable? and document.searchable.subdomain == subdomain
          filtered_docs << document
        end
      end
    end
    filtered_docs
  end
end
