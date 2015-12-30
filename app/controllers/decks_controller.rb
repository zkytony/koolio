class DecksController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]

  def index
    @decks = Deck.all
  end

  def new 
    @deck = Deck.new
  end

  def create
    args = prepare_arguments
    @deck = CreateDeck.call(deck_params, current_user, 
                            args[:open], args[:shared_editors], args[:shared_visitors],
                            args[:tags]);
    respond_to do |format|
      format.js
    end
  end

  def show
    @deck = Deck.find(params[:id])
    @more = params[:more] == "true"
    @all = params[:all] == "true"
    
    @grabbed_cards = GrabDeckCards.call(@deck, @more, @all, params[:card_ids])
    # user may want to create a card in this deck
    @card = Card.new 
    # user may want to make a comment
    @comment = Comment.new
  end

  def edit
    @deck = Deck.find(params[:id])
  end

  def update
    args = prepare_arguments
    @deck = Deck.find(params[:id])
    new_params = deck_params
    new_params[:open] = args[:open]
    @deck = UpdateDeck.call(new_params,
                            @deck, current_user,
                            args[:shared_editors], args[:shared_visitors],
                            args[:tags]);
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @deck = Deck.find(params[:id])
    @deck.destroy
    
    respond_to do |format|
      format.js
    end
  end

  def deck_info
    @deck = Deck.find(params[:deck_id])
    @info = GrabDeckInfo.call(@deck, current_user)
    
    respond_to do |format|
      format.json { render json: @info }
    end
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

  def card_show
    @deck = Deck.find(params[:deck_id])
    @more = params[:more] == "true"

    @grabbed_cards = GrabDeckCards.call(@deck, @more, true, params[:card_ids])
    # user may want to create a card in this deck
    @card = Card.new 
    # user may want to make a comment
    @comment = Comment.new
    render :show
  end

  private
    
    # strong parameter
    def deck_params
      params.require(:deck).permit(:title, :description, :user_id)
    end

    # return a hash object with "shared_editors", "shared_visitors",
    # "tags", "open" as its attributes. These attributes will be
    # needed for creating or updating a deck
    def prepare_arguments
      shared_editors = Set.new
      params[:deck_shared_editors].split(",").each do |email|
        shared_editors.add User.find_by(email: email)
      end

      shared_visitors = Set.new
      params[:deck_shared_visitors].split(",").each do |email|
        shared_visitors.add User.find_by(email: email)
      end

      tags = params[:item][:tags]
      
      return { 
        shared_editors: shared_editors, 
        shared_visitors: shared_visitors, 
        tags: tags, 
        open: params[:deck_property] == "public" 
      }
    end
end
