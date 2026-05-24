extends FloorModifier


func modify_floor() -> void:
	game_floor.floor_tags['less_hazard_damage'] = true

func clean_up() -> void:
	game_floor.floor_tags['less_hazard_damage'] = false

func get_mod_name() -> String:
	return "Secured Equipment"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/securedequipment.png")

func get_description() -> String:
	return "Obstacles are 25% less dangerous"

func get_mod_quality() -> ModType:
	return ModType.POSITIVE
