ShoppingCart::Engine.routes.draw do
  resource  :cart, only: [:show, :update]
  resources :order_items, only: [:create, :update, :destroy]
  resources :checkouts
  resources :orders, only: [:show, :index]
  resources :orders do
    get 'continue_shopping', on: :member
  end
end
