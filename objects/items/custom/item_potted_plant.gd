extends ItemScriptActive

const chomp = "res://audio/sfx/items/plantgrow.ogg"

const BANNED_SCENES: Array[String] = [
	'StrangerShop',
	'ElevatorScene',
]

func validate_use() -> bool:
	if SceneLoader.current_scene.name in BANNED_SCENES:
		return false
	else:
		return true

func use() -> void:
	var player := Util.get_player()
	
	player.stats.damage += 0.01
	player.stats.defense += 0.01
	player.stats.evasiveness += 0.01
	player.stats.luck += 0.01
	player.stats.speed += 0.01
	player.boost_queue.queue_text("Stats up!", Color("ff5555ff"))
	AudioManager.play_sound(load(chomp))
