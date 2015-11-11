class RecommendContent
  class GrabSelfLatestContent
    # Given user, and number of minutes 'x', return the contents
    # created by this user between within the given nubmer of
    # minutes from the current time.
    def self.call(user, x)
      content = user.cards.where(created_at: Date.current..x.minutes.ago)
      content |= user.decks.where(created_at: Date.current..x.minutes.ago)
      content
    end
  end
end
