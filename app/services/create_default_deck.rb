class CreateDefaultDeck
  # Check if there is a default deck associated with
  # given subdomain. If not, create a new deck for that
  # subdomain
  def self.call(user, subdomain="www")
    default_deck = "default"
    if subdomain != "www"
      default_deck = "default #{subdomain}.koolio"  # convention
    end
    if !user.decks.find_by(title: default_deck)
      deck_params = { title: default_deck, description: "This is #{user.username}'s default deck.", subdomain: subdomain }
      deck = user.create_deck(deck_params)
    end
  end
end
