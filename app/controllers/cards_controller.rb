class CardsController < ApplicationController
  def index
    @cards = Card.all
  end

  def new
    @deck = Deck.find(params[:deck_id])
    @card = Card.new
  end

  def create
    @deck = Deck.find(params[:deck_id])
    @card = @deck.build_card(card_params, current_user)
    if @card.save!
      flash[:success] = "Craeted a new card"
      redirect_to @deck
    else
      flash[:error] = "Unable to create card"
      redirect_to new_dcek_card_path
    end
  end

  def show
    @card = Card.find(params[:id])
  end

  private
    
    # strong parameter
    def card_params
      params.require(:card).permit(:front_content, :back_content, :deck_id, :user_id, :flips)
    end
end
