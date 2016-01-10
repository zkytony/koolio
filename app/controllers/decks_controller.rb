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
    @viewable = check_permission_to_view(@deck)
    if !@viewable
      render :show
    end
    # has the permission
    @more = params[:more] == "true"
    @all = params[:all] == "true"
    
    @grabbed_cards = GrabDeckCards.call(@deck, @more, @all, params[:card_ids])
    if logged_in?
      # user may want to create a card in this deck
      @card = Card.new 
      # user may want to make a comment
      @comment = Comment.new
    end
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

    respond_to do |format|
      format.js
    end
  end

  def unfavorite
    @deck = Deck.find(params[:deck_id])
    current_user.unfavor_deck(@deck)

    respond_to do |format|
      format.js
    end
  end

  def card_show
    @deck = Deck.find(params[:deck_id])
    @viewable = check_permission_to_view(@deck)
    if !@viewable
      render :show
    end

    @more = params[:more] == "true"

    @grabbed_cards = GrabDeckCards.call(@deck, @more, true, params[:card_ids])
    if logged_in?
      # user may want to create a card in this deck
      @card = Card.new 
      # user may want to make a comment
      @comment = Comment.new
    end
    render :show
  end

  # action for deleting cards
  def delete_cards
    @deck = Deck.find(params[:deck_id])
    if @deck.editable_by? current_user
      @card_ids = params[:card_ids]
      DeleteCardsInDeck.call(@deck, @card_ids)
      
      respond_to do |format|
        format.js
      end
    end
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
      shared_editors_param = params[:item][:shared_editors]
      if shared_editors_param
        shared_editors_param.split(",").each do |username|
          user = User.find_by(username: username)
          if user
            shared_editors.add user
          end
        end
      end

      shared_visitors = Set.new
      shared_visitors_param = params[:item][:shared_visitors]
      if shared_visitors_param
        shared_visitors_param.split(",").each do |username|
          user = User.find_by(username: username)
          if user
            shared_visitors.add user
          end
        end
      end

      tags = params[:item][:tags]
      
      return { 
        shared_editors: shared_editors, 
        shared_visitors: shared_visitors, 
        tags: tags, 
        open: params[:deck_property] == "public" 
      }
    end

    def check_permission_to_view(deck)
      if logged_in?
        if !deck.viewable_by? current_user
          return false
        end
      elsif !deck.explorable?
        return false
      end
      true
    end
end
