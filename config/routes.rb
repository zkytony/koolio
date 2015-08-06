Rails.application.routes.draw do
  root 'static_pages#index'
  resources :users
  resources :cards
  resources :decks
end
