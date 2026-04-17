extends ItemCharSetup

func first_time_setup(_player: Player) -> void:
	for track in Util.get_player().stats.gag_balance.keys():
		Util.get_player().stats.gag_regeneration[track] += 1
	Util.get_player().stats.gag_effectiveness['Squirt'] = 1.15
	Util.get_player().stats.gag_effectiveness['Throw'] = 1.15
	Util.get_player().stats.gag_cap = 15
	Util.get_player().stats.gag_discount = 0
