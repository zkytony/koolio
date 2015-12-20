class GrabProfileCards
  # Given a user and type, grab certain number of cards
  # 
  # type can either be "all" or "hot". "all" will result
  # in cards sorted by created time; "hot" will result in
  # cards sorted by the number of likes
  def self.call(user, type) 
    n_cards = 7
    cards = []
    if type == "all"
      cards = user.cards.sort_by(&:created_at).slice(0, n_cards)
      cards
    elsif type == "hot"
      cards = user.cards.sort_by(&:likes).slice(0, n_cards)
      cards
    else
      nil
    end
  end
end
