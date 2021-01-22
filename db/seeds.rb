Player.destroy_all
Player.reset_pk_sequence
Round.destroy_all
Round.reset_pk_sequence

started_seeding = Time.now

josh = Player.create( name: "Josh", password: "123", current_bankroll: 5000.0 )

done_seeding = Time.now

puts "♣️ ♦️ ♥️ ♠️ Seeded: #{ done_seeding - started_seeding } secs. ♣️ ♦️ ♥️ ♠️"
