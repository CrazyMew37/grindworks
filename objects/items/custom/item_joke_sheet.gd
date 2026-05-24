extends ItemScriptActive

const chomp = "res://audio/sfx/items/laff_boost_pickup.ogg"

const BANNED_SCENES: Array[String] = [
	'StrangerShop',
	'ElevatorScene',
]

const HP_BOOST := 5

func validate_use() -> bool:
	if SceneLoader.current_scene.name in BANNED_SCENES:
		return false
	else:
		return true

func get_hp_boost() -> int:
	return HP_BOOST + Util.get_player().stats.laff_boost_boost

func use() -> void:
	var player := Util.get_player()
	
	player.stats.max_hp += get_hp_boost()
	player.stats.hp += get_hp_boost()
	AudioManager.play_sound(load(chomp))
	Util.do_3d_text(Util.get_player(), "+%s" % get_hp_boost(), Color.GREEN, Color.DARK_GREEN)
