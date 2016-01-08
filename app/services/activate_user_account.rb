class ActivateUserAccount
  # Tries to activate the given user with the 
  # given token
  def self.call(user, token)
    if !user.activated?
      if @user.activation_digest == token
      @user.activate
      true
    end
  end
end
