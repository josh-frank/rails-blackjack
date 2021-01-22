class PlayersController < ApplicationController

  skip_before_action :authorize, only: [ :login_form, :login, :new, :create ]

  def login_form
  end

  def login
    player_logging_in = Player.find_by( name: params[ :name ] )
    if player_logging_in && player_logging_in.authenticate( params[ :password ] )
      session[ :player_id ] = player_logging_in.id
      redirect_to player_path( player_logging_in )
    else
      flash[ :messages ] = [ "Invalid username or password!" ]
      redirect_to login_path
    end
  end

  def logout
    session.delete( :player_id )
    flash[ :messages ] = [ "You are now logged out" ]
    redirect_to login_path
  end
  
  def index
    @all_players = Player.all
  end

  def new
    @new_player = Player.new
  end

  def create
    new_player = Player.create( player_params )
    if new_player.valid?
      new_player.update( current_bankroll: 1000.0 )
      session[ :player_id ] = new_player.id
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
    updated_player.update( player_params )
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

  def player_params
    params.require( :player ).permit( :name, :password, :password_confirmation )
  end

end
