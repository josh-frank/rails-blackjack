Rails.application.routes.draw do

  ########## LOG IN/out ##########

  get '/', to: 'players#login_form', as: 'login'
  post '/', to: 'players#login'

  delete '/', to: 'players#logout', as: 'logout'

  ########## PLAYERS ##########
    
  get 'players/new', to: 'players#new', as: 'new_player'
  post 'players/', to: 'players#create'
  
  get 'players/:id/edit', to: 'players#edit', as: 'edit_player'
  patch 'players/:id', to: 'players#update'
  
  get 'players/:id', to: 'players#show', as: 'player'

  ########## ROUNDS ##########

  get 'rounds/:id', to: 'rounds#show', as: 'round'
  
  post 'rounds/:player_id', to: 'rounds#new', as: 'new_round'

  patch 'rounds/:id/hit', to: 'rounds#hit', as: 'hit'

  patch 'rounds/:id/stand', to: 'rounds#stand', as: 'stand'

end
