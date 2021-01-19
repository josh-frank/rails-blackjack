class Player < ApplicationRecord

    has_many :rounds

    validates :name, presence: true, uniqueness: true

end
