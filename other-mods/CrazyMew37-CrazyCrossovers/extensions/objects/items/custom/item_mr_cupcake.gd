extends ItemScript

func on_collect(_item: Item, _object: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	Util.s_floor_started.connect(_on_floor_started)

func _on_floor_started(_game_floor: GameFloor) -> void:
	await Task.delay(0.5)
	Util.get_player().quick_heal(Util.get_player().stats.max_hp)
	AudioManager.play_sound(load("res://audio/sfx/battle/gags/toonup/sparkly.ogg"), 2.0)
