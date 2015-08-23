class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save!
      # redirect to users/:id
      flash[:success] = "Welcome to Koolio"
      log_in @user
      redirect_to @user
    else
      # Render the form again; 
      # Error will be displayed accordingly
      flash[:error] = "Error in your field"
      redirect_to root_path
    end
  end

  def show
    if logged_in?
      @user = User.find(params[:id])
    else
      redirect_to root_path
    end
  end

  def follow
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    redirect_to :back
  end

  def unfollow
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    redirect_to :back
  end

  private
    
    # strong parameter
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
end
