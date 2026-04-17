extends Object

func mole_hit(chain: ModLoaderHookChain) -> void:
	chain.reference_object.quota -= 1
	chain.reference_object.golf_ball_speed += chain.reference_object.get_spd_increment()
	if chain.reference_object.quota <= 0:
		chain.reference_object.win_game()
	else:
		if chain.reference_object.game_timer:
			chain.reference_object.set_timer_to_time(chain.reference_object.game_timer.timer.time_left + 2)
		else:
			chain.reference_object.set_timer_to_time(chain.reference_object.GameTimeBase)

func get_spd_increment(chain: ModLoaderHookChain) -> float:
	if Util.on_easy_floor():
		return 0.009
	return 0.014
