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
end
