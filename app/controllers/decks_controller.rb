class DecksController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]

  def index
    @decks = Deck.all
  end

  def new 
    @deck = Deck.new
  end

  def create
    @deck = current_user.decks.build(deck_params)
    if @deck.save!
      redirect_to @deck
    else
      redirect_to new_deck_path
    end
  end

  def show
    @deck = Deck.find(params[:id])
  end

  def edit
    @deck = Deck.find(params[:id])
  end

  def update
    @deck = Deck.find(params[:id])
    if @deck.update_attributes(deck_params)
      flash[:success] = "Deck information updated"
      redirect_to @deck
    else
      render 'edit'
    end
  end

  def destroy
    @deck = Deck.find(params[:id])
    @deck.destroy
    flash[:success] = "Deck deleted"
    redirect_to current_user
  end

  def favorite
    @deck = Deck.find(params[:deck_id])
    current_user.favor_deck(@deck)
    redirect_to @deck
  end

  def unfavorite
    @deck = Deck.find(params[:deck_id])
    current_user.unfavor_deck(@deck)
    redirect_to @deck
  end

  private
    
    # strong parameter
    def deck_params
      params.require(:deck).permit(:title, :description, :user_id)
    end
end
