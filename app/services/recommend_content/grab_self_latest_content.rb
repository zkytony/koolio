class RecommendContent
  class GrabSelfLatestContent
    # Given user, and number of minutes 'x', return the contents
    # created by this user between within the given nubmer of
    # minutes from the current time.
    def self.call(user, x)
      content = user.cards.where(created_at: x.minutes.ago..Time.current)
      content |= user.decks.where(created_at: x.minutes.ago..Time.current)
      content
    end
  end
end
