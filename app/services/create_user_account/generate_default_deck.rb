class CreateUserAccount
  class GenerateDefaultDeck
    def self.call(user)
      # Creates a default deck
      # If a card is not given a deck, it goes to this default deck
      deck_title = "default #{user.register_subdomain}.koolio"
      if user.register_subdomain === "www"
        deck_title = "default"
      end
      user.create_deck(title: deck_title, 
                       description: "Cards that were not given a deck goes to this deck.",
                       subdomain: user.register_subdomain)
    end
  end
end
