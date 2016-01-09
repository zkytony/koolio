class UserMailer < ApplicationMailer

  def signup_email(user)
    @user = user
    mail from: ENV["NOTIFICATION_EMAIL"], to: user.email, subject: "Sign up Confirmation"
  end

  def activate_email(user)
    @user = user
    mail from: ENV["NOTIFICATION_EMAIL"], to: user.email, subject: "Activate your account"
  end

  def reset_password_email(user)
    @user = user
    mail from: ENV["NOTIFICATION_EMAIL"], to: user.email, subject: "Reset password"
  end
end
