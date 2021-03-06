class CardsController < ApplicationController
  after_action :allow_iframe, only: :embed
  layout "blank", only: [:embed]
  
  def index
    @cards = Card.all
  end

  def new
    @deck = Deck.find(params[:deck_id])
    @card = Card.new
  end

  def create
    subdomain = ApplicationController.helpers.subdomain(request)
    CreateCard.call(card_params, current_user, params[:deck_id], subdomain)
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def show
    @card = Card.find(params[:id])
    redirect_to "/decks/#{@card.deck.id}/cards/#{@card.id}"
  end

  def edit
    @deck = Deck.find(params[:deck_id])
    @card = Card.find(params[:id])
  end

  def update
    @deck = Deck.find(params[:deck_id])
    @card = Card.find(params[:id])
    if @card.update_attributes(card_params)
      redirect_to @deck
    else
      render 'edit'
    end
  end

  def destroy
    @deck = Deck.find(params[:deck_id])
    @card = Card.find(params[:id])
    @card.destroy
    redirect_to @deck
  end

  def like
    # action triggered by ajax call
    @card = Card.find(params[:card_id])
    like = current_user.like_card(@card)

    @card.user.create_notification("LikeCard", like)

    respond_to do |format|
      format.js
    end
  end

  def unlike
    # action triggered by ajax call
    @card = Card.find(params[:card_id])
    current_user.unlike_card(@card)

    respond_to do |format|
      format.js
    end
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

  def embed
    @card = Card.find(params[:card_id])
  end
  
  private
  
  # strong parameter
  def card_params
    params.require(:card).permit(:front_content, :back_content, :deck_id, :user_id, :flips)
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
