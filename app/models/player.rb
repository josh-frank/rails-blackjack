class Player < ApplicationRecord

    has_many :rounds

    has_secure_password

    validates :name, presence: true, uniqueness: true

    after_create :set_starting_bankroll

    def winnings
        self.current_bankroll - self.starting_bankroll
    end

    private

    def set_starting_bankroll
        self.update( starting_bankroll: self.current_bankroll )
    end

end
