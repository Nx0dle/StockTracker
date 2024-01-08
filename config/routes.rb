Rails.application.routes.draw do
  devise_for :users
  root "stock_tracker#index"
end
