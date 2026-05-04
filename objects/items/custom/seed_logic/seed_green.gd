extends 'res://objects/items/custom/seed_logic/custom_seed_base.gd'

func on_collect(_item: Item, _object: Node3D) -> void:
	await Util.s_floor_started
	Util.get_player().last_damage_source = "being an absolute fool"
	await Task.delay(2.25)
	Util.get_player().stats.max_hp = 0
	Util.get_player().stats.hp = 0
