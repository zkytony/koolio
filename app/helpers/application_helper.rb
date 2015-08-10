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
end
