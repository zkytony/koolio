class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
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

  def show
    if logged_in?
      @user = User.find(params[:id])
      @more = params[:more] == "true"
      # more may be nil, since some request may not 
      # have this parameter
      @recommended = RecommendContent.call(@user, @more, params[:card_ids])

      # user may want to create a card in home page
      @card = Card.new 
      # user may want to make a comment
      @comment = Comment.new
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
    puts new_attrs
    if new_attrs
      UpdateUser.call(@user, new_attrs)
    end
    
  end

  private
    
    # strong parameter
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
end
