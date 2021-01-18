Rails.application.routes.draw do

  get 'rounds/', to: 'rounds#index', as: 'rounds'

  get 'rounds/:id', to: 'rounds#show', as: 'round'
  
  post 'rounds/:player_id', to: 'rounds#new', as: 'new_round'

  patch 'rounds/:id/hit', to: 'rounds#hit', as: 'hit'

  patch 'rounds/:id/stand', to: 'rounds#stand', as: 'stand'

end
