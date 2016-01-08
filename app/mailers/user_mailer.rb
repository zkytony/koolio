class UserMailer < ApplicationMailer
  default from: 'kaiyutony@gmail.com'

  def signup_email(user)
    @user = user
    mail to: user.email, subject: "Sign up Confirmation"
  end

  def activate_email(user)
    @user = user
    mail to: user.email, subject: "Activate your account"
  end
end
