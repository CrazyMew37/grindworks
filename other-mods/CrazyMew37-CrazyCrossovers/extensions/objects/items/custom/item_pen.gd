extends ItemScriptActive

const chomp = "res://audio/sfx/battle/cogs/attacks/SA_writeoff_pen_only.ogg"

func use() -> void:
	var player := Util.get_player()
	var game_floor := Util.floor_manager
	
	AudioManager.play_sound(load(chomp))
	
	# Make sure our instances are valid
	if not is_instance_valid(game_floor) or not is_instance_valid(player):
		return
		
	var anomaly_count = game_floor.anomalies.size()
	
	for anomaly in game_floor.anomalies.duplicate(true):
		game_floor.remove_anomaly(anomaly)
		Util.get_player().boost_queue.queue_text("Removed %s" % anomaly.get_mod_name(), anomaly.text_color)
	try_add_anomaly(game_floor, anomaly_count)

func try_add_anomaly(game_floor: GameFloor, anomaly_count: int) -> void:
	game_floor.spawn_new_anomalies(anomaly_count)
