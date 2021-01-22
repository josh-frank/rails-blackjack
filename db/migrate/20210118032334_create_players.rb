class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.string :name
      t.string :password_digest
      t.float :current_bankroll
      t.float :starting_bankroll

      t.timestamps
    end
  end
end
