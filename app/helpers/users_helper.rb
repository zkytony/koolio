module UsersHelper
  def login_form_flip
    if request.path == "/login"
      "flip"
    else
      ""
    end
  end

  def show_deck?(deck)
    (logged_in? && deck.viewable_by?(current_user)) || deck.explorable?
  end

  def user_avatar_url(user, side)
    avatar_url = user.my_avatar!(side)
    if avatar_url.nil?
      image_url("default-profile.svg")
    else
      avatar_url
    end
  end
end
