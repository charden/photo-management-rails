Rails.application.routes.draw do
  root "photos#index"
  resources :photos, only: %i[index new create]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
end
