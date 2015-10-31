class CreateUserAccount
  class GenerateDefaultDeck
    def self.call(user)
      # Creates a default deck
      # If a card is not given a deck, it goes to this default deck
      user.create_deck(title: "default", 
                       description: "Cards that were not given a deck goes to this deck.")                       
    end
  end
end
