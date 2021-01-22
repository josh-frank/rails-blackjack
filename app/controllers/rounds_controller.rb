class RoundsController < ApplicationController

  def index
    @all_rounds = Round.all
  end

  def new
    new_round = Round.create( player_id: params[ :player_id ], bet: params[ :next_bet ], dealer_cards: [], player_cards: [] )
    if new_round.valid?
      new_round.player.update( current_bankroll: new_round.player.current_bankroll - new_round.bet )
      new_round.player.update( current_bankroll: new_round.player.current_bankroll + new_round.bet * 3 ) if new_round.player_blackjack?
      redirect_to round_path( new_round )
    else
      flash[ :messages ] = new_round.errors.full_messages
      redirect_to params[ :round_id ] ? round_path( Round.find( params[ :round_id ] ) ) : player_path( Player.find( params[ :player_id ] ) )
    end
  end
  
  def show
    @this_round = Round.find( params[ :id ] )
  end
  
  def hit
    this_round = Round.find( params[ :id ] )
    this_round.update( player_cards: this_round.player_array + this_round.deck.pop( 1 ) )
    this_round.update( status: "bust" ) if this_round.player_bust?
    redirect_to round_path( this_round )
  end
  
  def stand
    this_round = Round.find( params[ :id ] )
    this_round.update( dealer_cards: this_round.dealer_array + this_round.deck.pop( 1 ) ) while ( this_round.dealer_score[ 0 ] > 21 ? this_round.dealer_score[ 1 ] : this_round.dealer_score.max ) < 17
    player_score = this_round.player_score[ 0 ] > 21 ? this_round.player_score[ 1 ] : this_round.player_score.max
    dealer_score = this_round.dealer_score[ 0 ] > 21 ? this_round.dealer_score[ 1 ] : this_round.dealer_score.max
    if player_score > dealer_score || this_round.dealer_bust?
      this_round.update( status: "win" )
      this_round.player.update( current_bankroll: this_round.player.current_bankroll + this_round.bet * 2 )
    elsif player_score == dealer_score
      this_round.update( status: "push" )
      this_round.player.update( current_bankroll: this_round.player.current_bankroll + this_round.bet )
    else
      this_round.update( status: "loss" )
    end
    redirect_to round_path( this_round )
  end

end
