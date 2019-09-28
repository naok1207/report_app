Rails.application.routes.draw do
  root   'users#index'

  get   '/profile', to: 'profiles#edit'
  patch '/profile', to: 'profiles#update'

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get   '/users/:id/followed', to: 'relationships#followed', as: 'followed'
  get   '/users/:id/follower', to: 'relationships#follower', as: 'follower'

  resources :users do
    resources :posts, only: [:show, :new, :create]
  end
  resources :relationships, only: [:create, :destroy]
  resources :account_activations, only: [:edit]
end
