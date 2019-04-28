Rails.application.routes.draw do
  devise_for :users
  resources :restaurants, except: [:destroy] do
    member do
      put 'vote', as: 'vote'
      put 'favorite', as: 'favorite'
    end
    resources :comments, only: [:index, :create, :destroy]
  end

  root 'restaurants#index'
  get 'page/:page', to: 'restaurants#page', as: :page
  get 'clear' => 'restaurants#clear_search'
  match '*path' => redirect('/'), via: :get
end
