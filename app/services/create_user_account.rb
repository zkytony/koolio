class CreateUserAccount
  def self.call(user)
    if user.save!
      GenerateDefaultDeck.call(user)
      true
    else
      false
    end
  end
end
