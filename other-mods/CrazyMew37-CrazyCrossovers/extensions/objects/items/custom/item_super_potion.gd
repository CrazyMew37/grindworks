extends ItemScriptActive

const chomp = "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/potionheal.ogg"

func validate_use() -> bool:
	return not Util.get_player().stats.hp == Util.get_player().stats.max_hp

func use() -> void:
	var player := Util.get_player()
	
	player.quick_heal(45)
	AudioManager.play_sound(load(chomp))
	queue_free()
