extends ItemScriptActive

const SFX := preload('res://audio/sfx/battle/cogs/attacks/SA_rubber_stamp.ogg')

func use() -> void:
	var player := Util.get_player()
	AudioManager.play_sound(SFX)
	player.boost_queue.queue_text("Stats sacrificed! Damage boosted!", Color("fc954cff"))
	var DefenseDown = player.stats.defense * 0.04
	var LuckDown = player.stats.luck * 0.04
	var EvasivenessDown = player.stats.evasiveness * 0.04
	var SpeedDown = player.stats.speed * 0.04
	player.stats.defense -= DefenseDown
	player.stats.luck -= LuckDown
	player.stats.evasiveness -= EvasivenessDown
	player.stats.speed -= SpeedDown
	player.stats.damage += DefenseDown + LuckDown + EvasivenessDown + SpeedDown
