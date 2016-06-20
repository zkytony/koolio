class StaticPagesController < ApplicationController
  def forgot_password
  end

  def terms_of_service
  end
  
  def privacy_policy
  end

  def about
    raise ActionController::RoutingError.new('Not Found')
  end
end
