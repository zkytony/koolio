module UsersHelper
  def login_form_flip
    if request.path == "/login"
      "flip"
    else
      request.path
    end
  end
end
