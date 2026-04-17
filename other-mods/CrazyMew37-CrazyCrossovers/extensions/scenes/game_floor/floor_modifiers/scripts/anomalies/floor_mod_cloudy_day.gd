extends FloorModifier

func modify_floor() -> void:
	BattleService.s_round_ended.connect(on_round_ended)

func on_round_ended(battle: BattleManager) -> void:
	var track_list: Array[Track] = Util.get_player().stats.character.gag_loadout.loadout.duplicate(true)
	if battle.current_round % 2 == 1:
		for track in track_list:
			var track_name := track.track_name
			if Util.get_player().stats.gag_balance[track_name] < Util.get_player().stats.gag_cap:
				Util.get_player().stats.gag_balance[track_name] -= Util.get_player().stats.gag_regeneration[track_name]
				print("Cloudy Day: Stats Subtracted!")

func get_mod_name() -> String:
	return "Cloudy Day"

func get_mod_icon() -> Texture2D:
	return load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pause/cloudyday.png")

func get_description() -> String:
	return "Gag points will only regenerate once every two rounds."

func get_mod_quality() -> ModType:
	return ModType.NEGATIVE
