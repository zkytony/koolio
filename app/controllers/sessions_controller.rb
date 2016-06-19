class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to current_user
    else
      render 'users/new'
    end
  end

  def create
    if session_params[:email].nil?
      identifier = session_params[:username] 
    else
      identifier = params[:email]
    end
    password = session_params[:password]    
    user = User.authenticate(identifier, password)
    if user
      # Check if user has a "default" deck for the current subdomain
      subdomain = ApplicationController.helpers.subdomain(request)
      CreateDefaultDeck.call(user, subdomain)

      log_in user
      redirect_to user
    else
      # error
      flash[:error] = 'Invalid email/password'
      redirect_to root_url
    end
  end

  def destroy
    log_out
    #redirect_to root_url
    #render 'users/new'
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :username, :password)
  end
  
end
