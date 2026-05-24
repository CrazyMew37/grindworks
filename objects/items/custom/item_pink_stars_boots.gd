extends ItemScript

const JB_BOOST := 10

func on_collect(_item: Item, _object: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	Util.s_floor_started.connect(_on_floor_started)

func get_jb_boost() -> int:
	return JB_BOOST * Util.get_player().stats.money_mult

func _on_floor_started(_game_floor: GameFloor) -> void:
	await Task.delay(0.5)
	Util.get_player().stats.money += get_jb_boost()
	AudioManager.play_sound(load("res://audio/sfx/ui/tick_counter.ogg"), 1.0)
