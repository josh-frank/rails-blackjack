Round.destroy_all
Round.reset_pk_sequence

started_seeding = Time.now

josh = Player.create( name: "Josh", bankroll: 1000.0 )

Round.create( player_id: josh.id, dealer_cards: [], player_cards: [] )

done_seeding = Time.now

puts "♣️ ♦️ ♥️ ♠️ Seeded: #{ done_seeding - started_seeding } secs. ♣️ ♦️ ♥️ ♠️"
