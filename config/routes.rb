Rails.application.routes.draw do
  resources :restaurants, except: [:destroy] do
    member do
      put 'vote_will_split', as: 'will_split'
      put 'vote', as: 'vote'
    end
    #put :vote_will_split, on: :member
  end

  root 'restaurants#index'

  match '*path' => redirect('/'), via: :get
end
