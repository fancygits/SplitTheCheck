Rails.application.routes.draw do
  resources :restaurants, except: [:destroy] do
    member do
      put 'vote', as: 'vote'
    end
  end

  root 'restaurants#index'
  get 'page/:page', to: 'restaurants#page', as: :page
  get 'clear' => 'restaurants#clear_search'
  match '*path' => redirect('/'), via: :get
end
