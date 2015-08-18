Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root 'users#new'
  
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
  get 'signup' => 'users#new'
  resources :users
  resources :cards
  resources :decks
end
