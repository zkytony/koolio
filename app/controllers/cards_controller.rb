class CardsController < ApplicationController
  def index
    @cards = Card.all
  end

  def new
    @deck = Deck.find(params[:deck_id])
    @card = Card.new
  end

  def create
    CreateCard.call(card_params, current_user, params[:deck_id])
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def show
    @card = Card.find(params[:id])
  end

  def edit
    @deck = Deck.find(params[:deck_id])
    @card = Card.find(params[:id])
  end

  def update
    @deck = Deck.find(params[:deck_id])
    @card = Card.find(params[:id])
    if @card.update_attributes(card_params)
      flash[:success] = "Card information updated"
      redirect_to @deck
    else
      render 'edit'
    end
  end

  def destroy
    @deck = Deck.find(params[:deck_id])
    @card = Card.find(params[:id])
    @card.destroy
    flash[:success] = "Card deleted"
    redirect_to @deck
  end

  def like
    @card = Card.find(params[:card_id])
    current_user.like_card(@card)
    redirect_to :back
  end

  def unlike
    @card = Card.find(params[:card_id])
    current_user.unlike_card(@card)
    redirect_to :back
  end

  def card_info
    @card = Card.find(params[:card_id])
    @info = GrabCardInfo.call(@card, current_user)
    if @info
      respond_to do |format|
        format.js
      end
    else
    end
  end

  private
  
  # strong parameter
  def card_params
    params.require(:card).permit(:front_content, :back_content, :deck_id, :user_id, :flips)
  end
end
