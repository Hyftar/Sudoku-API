Rails.application.routes.draw do
  post 'authenticate', to: 'authentication#authenticate'

  get 'play', to: 'games#peak'
  post 'join', to: 'games#create'
  post 'play', to: 'games#play'
  delete 'quit', to: 'games#destroy'

  resources :boards
end
