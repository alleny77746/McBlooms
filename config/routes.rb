Mcblooms::Application.routes.draw do
  resources :ingredients

  get "registration/new"
  mount Ckeditor::Engine => "/ckeditor"
  resources :categories do
    resources :products do
      resources :prices
    end
  end
  resources :pages

  resources :products do
    resources :prices
  end
  resource :cart, controller: :cart, path: 'your-basket', only: [:show, :destroy, :update] do
    resource :checkout, controller: :checkout, only: [:show, :create]
  end
  resources :my_orders, only: [:index, :show]

  post "my-basket/add/:product_id/:price_id", to: 'cart_items#update', as: :add_to_cart
  delete "my-basket/remove/:product_id/:price_id", to: 'cart_items#destroy', as: :remove_from_cart

  resource :my_profile, path: 'my-profile', controller: 'my_profile' do
    resources :addresses do
      member do
        post :mark_default
      end
    end
    resources :favorites, only: [:index, :update, :destroy]
  end

  get "register", to: 'registration#new', as: :registration
  post "register", to: 'registration#create'

  resources :menus
  resources :users

  get "signin", to: "sessions#new", as: :signin
  get "signout", to: "sessions#destroy", as: :signout
  resources :sessions, only: [:create]
  resources :password_reset, only: [:new, :create, :edit, :update], controller: :password_reset

  root 'home#index'
end
