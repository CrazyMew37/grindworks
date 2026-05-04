extends 'res://objects/items/custom/seed_logic/custom_seed_base.gd'


# Sketched
func _ready() -> void:
	Util.s_floor_started.connect(on_floor_start)

func on_floor_start(gfloor: GameFloor) -> void:
	await Task.delay(1.0)
	Util.get_player().boost_queue.queue_text("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", Color.WHITE)
