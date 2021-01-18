class CreateRounds < ActiveRecord::Migration[6.1]
  def change
    create_table :rounds do |t|
      t.integer :player_id
      t.float :bet
      t.string :dealer_cards
      t.string :player_cards
      t.string :status

      t.timestamps
    end
  end
end
