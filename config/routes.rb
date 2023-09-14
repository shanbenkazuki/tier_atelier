Rails.application.routes.draw do
  resources :users
  get 'tiers/search', to: 'tiers#search', as: :search
  resources :tiers do
    member do
      put 'items', to: 'items#update'
    end
  end
  resources :items
  root 'top#index'
  get 'privacy_policy', to: 'top#privacy_policy'
  get 'terms_of_use', to: 'top#terms_of_use'
  get 'login' => 'user_sessions#new', :as => :login
  post 'login' => "user_sessions#create"
  post 'logout' => 'user_sessions#destroy', :as => :logout
  post 'screenshot', to: 'screenshots#create'
  get 'screenshot/download', to: 'screenshots#download', as: :screenshot_download
end
