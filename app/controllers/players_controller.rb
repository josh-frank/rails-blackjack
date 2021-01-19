class PlayersController < ApplicationController
  
  def index
    @all_players = Player.all
  end

  def new
    @new_player = Player.new
  end

  def create
    new_player = Player.create( player_params( :name ) )
    if new_player.valid?
      new_player.update( bankroll: 1000.0 )
      redirect_to player_path( new_player )
    else
      flash[ :messages ] = new_player.errors.full_messages
      redirect_to new_player_path
    end
  end

  def edit
    @this_player = Player.find( params[ :id ] )
  end

  def update
    updated_player = Player.find( params[ :id ] )
    updated_player.update( player_params( :name ) )
    if updated_player.valid?
      redirect_to player_path( updated_player )
    else
      flash[ :messages ] = updated_player.errors.full_messages
      redirect_to edit_player_path
    end
  end

  def show
    @this_player = Player.find( params[ :id ] )
  end

  private

  def player_params( *args )
    params.require( :player ).permit( *args )
  end

end
