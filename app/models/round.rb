#                    A,  2,  3,  4,  5,  6,  7,  8,  9, 10,  J,  Q,  K,  A
#    clubs = [ nil, 49,  1,  5,  9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49 ]
# diamonds = [ nil, 50,  2,  6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50 ]
#   hearts = [ nil, 51,  3,  7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51 ]
#   spades = [ nil, 52,  4,  8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52 ]

class Integer
    def suit; ( self - 1 ) % 4; end
    def rank; ( ( self - 1 ) / 4 ) + 2; end
end

class Round < ApplicationRecord

    belongs_to :player

    validates :bet, numericality: { greater_than: 0, message: "must be greater than 0" }
    validates :bet, numericality: { less_than_or_equal_to: 100, message: "limit: $100" }
    validate :bet_less_than_bankroll

    after_create :deal

    def dealer_array
        self.dealer_cards[ 1...-1 ].split( ", " ).map( &:to_i  )
    end

    def player_array
        self.player_cards[ 1...-1 ].split( ", " ).map( &:to_i  )
    end

    def deck
        self.class.full_deck - player_array - dealer_array
    end

    def dealer_score
        self.class.score( dealer_array )
    end
    
    def player_score
        self.class.score( player_array )
    end

    def dealer_bust?
        self.class.score( dealer_array )[ 1 ] > 21
    end
    
    def player_bust?
        self.class.score( player_array )[ 1 ] > 21
    end

    def dealer_blackjack?
        self.class.score( dealer_array )[ 0 ] == 21 || self.class.score( dealer_array )[ 1 ] == 21
    end

    def player_blackjack?
        self.class.score( player_array )[ 0 ] == 21 || self.class.score( player_array )[ 1 ] == 21
    end
    
    def self.card_names
        ["2 of ", "3 of ", "4 of ", "5 of ", "6 of ", "7 of ", "8 of ", "9 of ", "10 of ", "Jack of ", "Queen of ", "King of ", "Ace of " ].product( [ "Clubs", "Diamonds", "Hearts", "Spades" ] ).map( &:join ).unshift( nil )
    end
    
    private

    def bet_less_than_bankroll
        if self.bet > self.player.bankroll
            errors.add( :bet, "must be covered by bankroll" )
        end
    end
    
    def deal
        self.update( dealer_cards: self.deck.pop( 2 ) )
        self.update( player_cards: self.deck.pop( 2 ) )
        self.update( status: "blackjack" ) if self.player_blackjack?
    end
    
    def self.full_deck
        ( 1..52 ).to_a.shuffle
    end

    # [ soft_score, hard_score ]
    # [ score_when_aces_are_eleven, score_when_aces_are_one ]
    def self.score( hand_array )
        score, number_of_aces = 0, 0
        hand_array.each do | card |
            number_of_aces += 1 if card.rank == 14
            case
            when card.rank == 14
                score += 11
            when card.rank > 9
                score += 10
            else
                score += card.rank
            end 
        end
        [ score, score - ( number_of_aces * 11 ) + number_of_aces ]
    end

end
