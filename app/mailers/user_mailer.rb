class UserMailer < ApplicationMailer

  def signup_email(user)
    if ENV['ENABLE_MAILER'].downcase == 'on'
      @user = user
      mail from: ENV["NOTIFICATION_EMAIL"], to: user.email, subject: "Sign up Confirmation"
    end
  end

  def activate_email(user)
    if ENV['ENABLE_MAILER'].downcase == 'on'
      @user = user
      mail from: ENV["NOTIFICATION_EMAIL"], to: user.email, subject: "Activate your account"
    end
  end

  def reset_password_email(user)
    if ENV['ENABLE_MAILER'].downcase == 'on'
      @user = user
      mail from: ENV["NOTIFICATION_EMAIL"], to: user.email, subject: "Reset password"
    end
  end
end
