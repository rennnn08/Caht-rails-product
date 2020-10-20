Rails.application.routes.draw do
  get 'userbelongsrooms/index'
  get 'users/index'
  resources :post
  resources :rooms, only: [:index, :show, :create, :destroy]
  post '/toakcreate', to: 'rooms#toakcreate'
  resources :messages, only: [:index, :create]
  post '/signup', to: 'registrations#signup'
  mount ActionCable.server => '/cable'
  post '/login', to: 'sessions#login'
  delete '/logout', to: 'sessions#logout'
  get '/logged_in', to: 'sessions#logged_in?'
  get '/loginuser', to: 'users#loginUser'
  resources :users, only: [:index, :show, :update]
  resources :userbelongsrooms, only: [:index, :create, :destroy]
  get '/getuser_ids', to: 'userbelongsrooms#user_ids'
end
