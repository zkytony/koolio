module SessionsHelper
  def log_in(user)
    # session is a default rails array
    cookies.permanent.signed[:user_id] = user.id
  end

  def log_out
    cookies.delete(:user_id)
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find_by(id: cookies.permanent.signed[:user_id])
  end

  def logged_in?
    # is current_user nil?
    !current_user.nil?
  end
end
