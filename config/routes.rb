Rails.application.routes.draw do
  resources :user_stocks, only: [:create, :destroy]
  resources :friendships, only: [:create, :destroy]
  devise_for :users
  root "stock_tracker#index"
  get "my_portfolio", to: "users#my_portfolio"
  get "my_friends", to: "users#my_friends"
  get "search_friends", to: 'users#search'
  get 'search_stock', to: 'stocks#search'
  resources :users, only: [:show]
end
