Rails.application.routes.draw do
  resources :users
  resources :tiers do
    collection do
      get 'search', to: 'tiers#search'
      post 'create_from_template', to: 'tiers#create_from_template'
    end

    member do
      get 'arrange', to: 'tiers#arrange'
    end

    resources :items, only: [:create, :update, :destroy]
    resources :templates, only: [:new, :create]
  end

  resources :templates, except: [:new, :create]

  root 'top#index'
  get 'privacy_policy', to: 'top#privacy_policy'
  get 'terms_of_use', to: 'top#terms_of_use'
  get 'login' => 'user_sessions#new', :as => :login
  post 'login' => "user_sessions#create"
  post 'logout' => 'user_sessions#destroy', :as => :logout
end
