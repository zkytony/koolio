class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    if logged_in?
      redirect_to current_user
    end
    @user = User.new
  end

  def create
    # if username or email already exists, redirect
    # to root with such messages
    email_exists = User.exists?(email: user_params[:email]) 
    username_exists = User.exists?(username: user_params[:username]) 
    if email_exists || username_exists
      if email_exists && username_exists
        flash[:error] = "username AND email both already used"
      elsif email_exists
        flash[:error] = "email already used"
      else
        flash[:error] = "username already taken"
      end
      redirect_to root_path 
    else
      # Able to create a new user
      @user = User.new(user_params)
      if CreateUserAccount.call(@user)
        flash[:success] = "Welcome! #{@user.username}"
        log_in @user
        redirect_to @user
      else
        # Not able to create
        redirect_to root_path
      end
    end
  end

  def activate
    @user = User.find(params[:id])
    token = params[:tk]
    if !@user.activated? # if the user is not yet activated
      if @user.activate(token)
        # user is now activated. log in the user
        log_in @user
        flash[:success] = "Your account is activated"
        redirect_to @user
      else
        flash[:error] = "Error occurred in visiting page"
        redirect_to root_path
      end
    else
      # if the user is already activated, this action does nothing
      # so redirect to root path
      redirect_to root_path
    end
  end

  def show
    if logged_in?
      if current_user.id.to_s != params[:id]
        raise ActionController::RoutingError.new('Not Found')
      else
        @user = current_user
        @more = params[:more] == "true"
        # more may be nil, since some request may not 
        # have this parameter
        @recommended = RecommendContent.call(@user, @more, params[:card_ids], :home)

        # default deck
        @deck = current_user.first_deck
        # user may want to create a card in home page
        @card = Card.new 
        # user may want to make a comment
        @comment = Comment.new
      end
    else
      redirect_to root_path
    end
  end

  # explore page. grab the popular only
  def explore
    @more = params[:more] == "true"
    if logged_in?
      @recommended = RecommendContent.call(current_user, @more, params[:card_ids], :explore)

      # user may want to make a comment
      @comment = Comment.new

      respond_to do |format|
        format.html
        format.js
      end
    else
      # explore without user sepcified
      @recommended = RecommendContent.call(nil, @more, params[:card_ids], :explore)
    end
  end

  def follow
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    
    respond_to do |format|
      format.js
    end
  end

  def unfollow
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)

    respond_to do |format|
      format.js
    end
  end

  def profile
    @user = User.find(params[:user_id])
    if logged_in?
      @can_create_deck = @user.id == current_user.id && @user.activated?
      if @can_create_deck
        @deck = Deck.new # user may want to create a deck
      end
    end
  end

  # cards to display in the profile page
  def profile_cards
    @type = params[:type]
    @user = User.find(params[:user_id])
    @more = params[:more] == "true"
    card_ids = params[:card_ids]
    @profile_cards = GrabProfileCards.call(@user, @type, @more, card_ids)
    # user may want to make a comment
    @comment = Comment.new

    respond_to do |format|
      format.js
    end
  end

  # decks to display in the profile page
  def profile_decks
    @user = User.find(params[:user_id])
    @more = params[:more] == "true"
    deck_ids = params[:deck_ids]
    @profile_decks = GrabProfileDecks.call(@user, @more, deck_ids)
    @can_create_deck = @user.id == current_user.id && @user.activated?
    
    respond_to do |format|
      format.js
    end
  end

  # Goes to decks tab in profile page
  def decks_list
    @user = User.find(params[:user_id])
    if logged_in?
      @can_create_deck = @user.id == current_user.id && @user.activated?
      if @can_create_deck
        @deck = Deck.new # user may want to create a deck
      end
    end
    render :profile
  end

  # settings
  def settings
    @user = User.find(params[:user_id])
    if logged_in? && current_user.id === @user.id
      
    else
      # not found
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  # update
  def update
    @user = User.find(params[:id])
    new_attrs = params[:new_attrs]
    if new_attrs
      @user = UpdateUser.call(@user, new_attrs)
    end
    
    respond_to do |format|
      format.js
    end
  end

  # get notifications for current user
  def notifications
    @notifs = GrabNotifications.call(current_user)

    respond_to do |format|
      format.js
    end
  end

  # get a list of mutually_followed users of the current user in json
  def mutual_follows
    @user = User.find(params[:user_id])
    users = @user.mutual_follows
    
    respond_to do |format|
      format.json { render json: { users: users } }
    end
  end
  
  def init_reset_password
    # send the email for resetting password
    @user = User.find_by(email: params[:email])
    if @user
      @user.update_attributes(reset_digest: SecureRandom.base58(24), reset_at: Time.now)
      UserMailer.reset_password_email(@user).deliver_later
    end

    respond_to do |format|
      @link_sent = true
      format.html { render :template => 'static_pages/forgot_password' }
    end
  end

  def validate_reset_password    
    @user = User.find(params[:id])
    @token = params[:tk]

    if (@user.reset_digest == @token) && @user.reset_at.between?(24.hours.ago, Time.now)
      # user clicked the email link within 24 hours
    else
      # something wrong.
      flash[:warning] = "Something went wrong."
      redirect_to root_url
    end
  end

  def exec_reset_password
    @user = User.find(params[:id])
    token = params[:tk]

    if (@user.reset_digest == token) && @user.reset_at.between?(24.hours.ago, Time.now)
      # user tries to reset within 24 hours
      pw = params[:password]
      pw_confirm = params[:re_password]
      if pw == pw_confirm
        # set the password
        @user.password = pw
        @user.password_confirmation = pw_confirm
        # invalidate the current reset token
        @user.reset_digest = nil
        @user.reset_at = nil
        @user.save!
        flash[:success] = "Password reset was successful."
        redirect_to root_path
      else
        flash[:success] = "Error occurred in visiting page."
        redirect_to :back
      end
    end
  end

  # get list of users matching the given type and render json
  def listings
    user = User.find(params[:user_id])
    @type = params[:type]
    @list = GrabUsersList.call(user, @type)

    respond_to do |format|
      format.js
    end
  end

  private
    
    # strong parameter
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
end
