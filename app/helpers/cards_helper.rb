module CardsHelper
  def all_hidden_to(cards, user)
    if user.nil?
      return true
    end
    cards.each do |card|
      if card.viewable_by?(user)
        return false
      end
    end
    true
  end
end
