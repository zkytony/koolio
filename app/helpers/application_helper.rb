module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Koolio"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def nav_signup_link
    path = request.path
    if path == root_path or path == login_path or path == signup_path
      "#"
    else
      signup_path
    end
  end

  def nav_login_link
    path = request.path
    if path == root_path or path == login_path or path == signup_path
      "#"
    else
      login_path
    end
  end

  def nav_logo_link
    if logged_in?
      current_user
    else
      explore_path
    end
  end

  def render_card(card, category_class)
    card_front = JSON.parse(card.front_content)
    card_back = JSON.parse(card.back_content)

    liked = nil
    if current_user 
      liked = current_user.liked_card?(card)
    end

    render partial: "shared/card", locals: { 
      category_class: category_class, 
      card_id: card.id,
      card_front_type: card_front['type'], 
      card_front_content: card_front['content'],
      card_back_type: card_back['type'], 
      card_back_content: card_back['content'],
      current_user_liked_card: liked
    }
  end

  # Helps to get subdomain from a given request object.
  # If subdomain is empty, return 'www'
  def subdomain(request):
      if request.subdomain.length > 0 && request.subdomain != "www"
        request.subdomain
      else
        "www"
      end
  end
end
