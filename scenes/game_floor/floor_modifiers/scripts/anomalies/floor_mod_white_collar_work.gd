extends FloorModifier


## Multiplies the room count of the floor
func modify_floor() -> void:
	game_floor.floor_tags['more_battle_rooms'] = true

func get_mod_name() -> String:
	return "White Collar Work"

func get_mod_quality() -> ModType:
	return ModType.NEUTRAL

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/whitecollarwork.png")

func get_description() -> String:
	return "This floor has 25% more battle rooms than usual."
