module UsersHelper
  def login_form_flip
    if request.path == "/login"
      "flip"
    else
      ""
    end
  end
end
