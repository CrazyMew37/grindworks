extends FloorModifier

var gag_amount := -2

func modify_floor() -> void:
	await Task.delay(0.5)
	var player := Util.get_player()
	player.stats.gag_discount += gag_amount

func clean_up() -> void:
	var player := Util.get_player()
	player.stats.gag_discount -= gag_amount

func get_mod_name() -> String:
	return "Surtax"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/pricehike.png")

func get_description() -> String:
	return "Gags cost 2 points more"

func get_mod_quality() -> ModType:
	return ModType.NEGATIVE
