extends ItemScriptActive

const SFX := preload("res://audio/sfx/ui/tick_counter.ogg")

func use() -> void:
	
	var player_stats := Util.get_player().stats
	player_stats.add_money(RNG.channel(RNG.ChannelPrankBeanJarRolls).randi_range(3, 6))
	AudioManager.play_sound(SFX)
