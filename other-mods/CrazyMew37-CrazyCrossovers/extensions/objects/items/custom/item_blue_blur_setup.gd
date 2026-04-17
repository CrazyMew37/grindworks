extends ItemCharSetup

func first_time_setup(_player: Player) -> void:
	for track in Util.get_player().stats.gag_balance.keys():
		Util.get_player().stats.gag_regeneration[track] += 1
