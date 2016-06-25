module CardsHelper
  def all_hidden_to(cards, user)
    cards.each do |card|
      if user.nil?
        if card.explorable?
          return false
        end
      else
        if card.viewable_by?(user)
          return false
        end
      end
    end
    true
  end
end
