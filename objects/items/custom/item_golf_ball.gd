extends ItemScriptActive

const SFX := preload('res://audio/sfx/battle/cogs/attacks/SA_tee_off.ogg')

func use() -> void:
	AudioManager.play_sound(SFX)
	var result := randi_range(1,4)
	if result == 1:
		Util.get_player().stats.sellbot_boost += 0.05
		Util.get_player().boost_queue.queue_text("Boosted Sellbot Damage and Defense!", Color("aa00aaff"))
	elif result == 2:
		Util.get_player().stats.cashbot_boost += 0.05
		Util.get_player().boost_queue.queue_text("Boosted Cashbot Damage and Defense!", Color("00aa00ff"))
	elif result == 3:
		Util.get_player().stats.lawbot_boost += 0.05
		Util.get_player().boost_queue.queue_text("Boosted Lawbot Damage and Defense!", Color("0055aaff"))
	elif result == 4:
		Util.get_player().stats.bossbot_boost += 0.05
		Util.get_player().boost_queue.queue_text("Boosted Bossbot Damage and Defense!", Color("aa5500ff"))
