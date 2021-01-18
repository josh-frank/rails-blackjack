class RoundsController < ApplicationController

  def index
    @all_rounds = Round.all
  end

  def new
    new_round = Round.create( player_id: params[ :player_id ], dealer_cards: [], player_cards: [] )
    redirect_to round_path( new_round )
  end
  
  def show
    @this_round = Round.find( params[ :id ] )
  end
  
  def hit
    this_round = Round.find( params[ :id ] )
    this_round.update( player_cards: this_round.player_array + this_round.deck.pop( 1 ) )
    this_round.update( status: "bust" ) if this_round.player_bust?
    if this_round.player_score.include?( 21 )
      redirect_to stand_path( this_round )
    else
      redirect_to round_path( this_round )
    end
  end
  
  def stand
    this_round = Round.find( params[ :id ] )
    this_round.update( dealer_cards: this_round.dealer_array + this_round.deck.pop( 1 ) ) while ( this_round.dealer_score[ 0 ] > 21 ? this_round.dealer_score[ 1 ] : this_round.dealer_score.max ) < 17
    player_score = this_round.player_score[ 0 ] > 21 ? this_round.player_score[ 1 ] : this_round.player_score.max
    dealer_score = this_round.dealer_score[ 0 ] > 21 ? this_round.dealer_score[ 1 ] : this_round.dealer_score.max
    if player_score > dealer_score || this_round.dealer_bust?
      this_round.update( status: "win" )
    elsif player_score == dealer_score
      this_round.update( status: "push" )
    else
      this_round.update( status: "loss" )
    end
    redirect_to round_path( this_round )
  end

end
