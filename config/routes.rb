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
    post 'favorite' => 'decks#favorite'
    delete 'unfavorite' => 'decks#unfavorite'
  end
  # Also want to have paths for cards directly
  resources :cards do
    post 'like' => 'cards#like'
    delete 'unlike' => 'cards#unlike'
    get 'card_info' => 'cards#card_info'
  end
  
  # comments are accessed directly
  resources :comments

  resources :uploaded_files, only: [:destroy, :create]

  post 'userfiles' => 'uploaded_files#create'
  delete 'userfiles' => 'uploaded_files#destroy'
end
