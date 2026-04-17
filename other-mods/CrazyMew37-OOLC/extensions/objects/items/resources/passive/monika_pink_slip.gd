extends ItemScript

func on_collect(_item: Item, _object: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	Util.s_floor_started.connect(on_floor_start)

func on_floor_start(_game_floor: GameFloor) -> void:
	await Task.delay(0.5)
	Util.get_player().stats.pink_slips += 1
