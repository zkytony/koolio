class DecksController < ApplicationController
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

  private
    
    # strong parameter
    def deck_params
      params.require(:deck).permit(:title, :description, :user_id)
    end
end
