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
    resources :cards do
      post 'like' => 'cards#like'
      delete 'unlike' => 'cards#unlike'
    end
  end
end
