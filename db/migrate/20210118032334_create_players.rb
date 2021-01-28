class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.string :name
      t.string :password_digest
      t.float :current_bankroll, default: 1000.0
      t.float :starting_bankroll

      t.timestamps
    end
  end
end
