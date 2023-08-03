Rails.application.routes.draw do
  resources :users
  get 'tiers/search', to: 'tiers#search', :as => :search
  resources :tiers do
    collection do
      get :make
    end
  end
  root 'top#index'
  get 'privacy_policy', to: 'top#privacy_policy'
  get 'terms_of_use', to: 'top#terms_of_use'
  get 'login' => 'user_sessions#new', :as => :login
  post 'login' => "user_sessions#create"
  post 'logout' => 'user_sessions#destroy', :as => :logout
end
