Rails.application.routes.draw do
  resources :users

  resources :tiers do
    collection do
      get 'search', to: 'tiers#search'
    end

    member do
      get 'arrange', to: 'tiers#arrange'
      post 'update_tier_cover_image', to: 'tiers#update_tier_cover_image'
      post 'create_from_template', to: 'tiers#create_from_template'
    end

    resources :items, only: [:create, :update, :destroy] do
      collection do
        post 'bulk_update_items'
      end
    end
  end

  resources :templates do
    member do
      post 'drop_image', to: 'templates#drop_image'
    end
  end

  root 'top#index'
  get 'privacy_policy', to: 'top#privacy_policy'
  get 'terms_of_use', to: 'top#terms_of_use'
  get 'login' => 'user_sessions#new', :as => :login
  post 'login' => "user_sessions#create"
  post 'logout' => 'user_sessions#destroy', :as => :logout
end
