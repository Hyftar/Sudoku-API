Rails.application.routes.draw do
  post 'authenticate', to: 'authentication#authenticate'
  get 'boards/random', to: 'boards#random'
  resources :boards do
    post 'play', to: 'boards#play', on: :member
  end
end
