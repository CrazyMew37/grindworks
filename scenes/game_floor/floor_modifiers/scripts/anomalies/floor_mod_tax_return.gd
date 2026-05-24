extends FloorModifier

var gag_amount := 1

func modify_floor() -> void:
	await Task.delay(0.5)
	var player := Util.get_player()
	player.stats.gag_discount += gag_amount

func clean_up() -> void:
	var player := Util.get_player()
	player.stats.gag_discount -= gag_amount

func get_mod_name() -> String:
	return "Tax Return"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/taxreturn.png")

func get_description() -> String:
	return "Gags cost 1 point less"
	
func get_mod_quality() -> ModType:
	return ModType.POSITIVE
