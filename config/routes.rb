Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root 'users#new'
  
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
  get 'signup' => 'users#new'
  resources :users do
    post 'follow' => 'users#follow'
    delete 'unfollow' => 'users#unfollow'
  end
  resources :decks do
    resources :cards
  end
end
