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
    @user = User.new(user_params)
    if CreateUserAccount.call(@user)
      log_in @user
      redirect_to @user
    else
      # Not able to create
      redirect_to root_path
    end
  end

  def activate
    @user = User.find(params[:id])
    token = params[:tk]
    if !@user.activated? # if the user is not yet activated
      if @user.activation_digest == token
        @user.activate
        # user is now activated. log in the user
        log_in @user
        redirect_to @user
      else
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
      @user = User.find(params[:id])
      @more = params[:more] == "true"
      # more may be nil, since some request may not 
      # have this parameter
      @recommended = RecommendContent.call(@user, @more, params[:card_ids], :home)

      # default deck
      @deck = @user.decks.first #find_by(title: "default")
      # user may want to create a card in home page
      @card = Card.new 
      # user may want to make a comment
      @comment = Comment.new
    else
      redirect_to root_path
    end
  end

  # explore page. grab the popular only
  def explore
    if logged_in?
      @more = params[:more] == "true"
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
    if @user.id == current_user.id
      @deck = Deck.new # user may want to create a deck
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
    
    respond_to do |format|
      format.js
    end
  end

  # settings
  def settings
    @user = User.find(params[:user_id])
    if logged_in? && current_user.id === @user.id
      
    else
      redirect_to :back
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
      render nothing: true
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
        redirect_to root_path
      else
        redirect_to :back
      end
    end
  end

  private
    
    # strong parameter
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
end
