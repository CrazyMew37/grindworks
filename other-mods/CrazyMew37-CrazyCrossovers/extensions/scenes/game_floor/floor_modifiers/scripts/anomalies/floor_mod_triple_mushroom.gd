extends FloorModifier

var floor_mod = 0.3

func modify_floor() -> void:
	if Util.floor_number > 5:
		floor_mod = 0.3 * (1 + (floor((Util.floor_number - 1) / 5) * 0.5))
	Util.get_player().stats.speed += floor_mod

func clean_up() -> void:
	Util.get_player().stats.speed -= floor_mod

func get_mod_name() -> String:
	return "Triple Mushroom"

func get_mod_quality() -> ModType:
	return ModType.POSITIVE

func get_mod_icon() -> Texture2D:
	return load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pause/triplemushroom.png")

func get_description() -> String:
	return "+30% Speed for the floor (Increases by +15% every five floors with Endless)"
