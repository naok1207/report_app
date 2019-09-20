Rails.application.routes.draw do
  root   'users#index'

  get   '/profile', to: 'profiles#edit'
  patch '/profile', to: 'profiles#update'

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users do
    resources :posts, only: [:index, :new, :create]
  end
end
