class CreateUserAccount
  def self.call(user)
    if user.save!
      UserMailer.activate_email(user).deliver_later
      GenerateDefaultDeck.call(user)
      true
    else
      false
    end
  end
end
