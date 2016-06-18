
Rails.application.routes.draw do
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  root 'users#new'
  
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  get 'signup' => 'users#new'
  get 'notifications' => 'users#notifications'
  get 'explore' => 'users#explore'
  
  get 'search/*query' => 'searches#search'
  get 'activate' => 'users#activate'
  get 'forgot_password' => 'static_pages#forgot_password'
  post 'init_reset_password' => 'users#init_reset_password'
  get 'password' => 'users#validate_reset_password'
  post 'reset_password' => 'users#exec_reset_password'
  
  get 'users/listings' => 'users#listings'

  resources :users do
    post 'follow' => 'users#follow'
    post 'unfollow' => 'users#unfollow'
    get 'profile' => 'users#profile'
    get 'profile_cards' => 'users#profile_cards'
    get 'profile_decks' => 'users#profile_decks'
    get 'profile/decks' => 'users#decks_list'
    get 'settings' => 'users#settings'
    get 'mutual_follows' => 'users#mutual_follows'
  end
  resources :decks do
    post 'favorite' => 'decks#favorite'
    post 'unfavorite' => 'decks#unfavorite'
    get 'deck_info' => 'decks#deck_info'
    get 'cards/:card_id' => 'decks#card_show'
    post 'delete_cards' => 'decks#delete_cards'
  end
  # Also want to have paths for cards directly
  resources :cards do
    post 'like' => 'cards#like'
    delete 'unlike' => 'cards#unlike'
    get 'card_info' => 'cards#card_info'
  end
  
  # comments are accessed directly
  resources :comments do
    post 'like' => 'comments#like'
    delete 'unlike' => 'comments#unlike'
  end

  resources :uploaded_files, only: [:destroy, :create]

  post 'userfiles' => 'uploaded_files#create'
  delete 'userfiles' => 'uploaded_files#destroy'
end
