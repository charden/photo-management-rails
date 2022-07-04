Rails.application.routes.draw do
  root "photos#index"
  resources :photos, only: %i[index new create] do
    member do
      get 'tweet'
    end
  end
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'oauth/new'
  get 'oauth/callback'
end
