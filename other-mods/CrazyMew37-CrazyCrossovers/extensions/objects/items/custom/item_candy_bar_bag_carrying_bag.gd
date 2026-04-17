extends ItemScriptActive

const SUPER_CHANCE := 0.15


func use() -> void:
	var _item: String
	var zone
	if is_instance_valid(Util.floor_manager):
		zone = Util.floor_manager.get_current_room()
	else:
		zone = SceneLoader
	if randf() < Util.get_relevant_player_stats().get_luck_weighted_chance(SUPER_CHANCE, 0.3, 2.0):
		_item = "res://objects/items/resources/passive/gag_voucher_pack.tres"
	else:
		_item = "res://objects/items/resources/passive/gag_voucher_small.tres"
	var world_item: WorldItem = load('res://objects/items/world_item/world_item.tscn').instantiate()
	world_item.item = load(_item)
	SceneLoader.current_scene.add_child(world_item)
	world_item.global_position = Util.get_player().toon.to_global(Vector3(0, 0.6, 2.0))
	var dust_cloud = Globals.DUST_CLOUD.instantiate()
	zone.add_child(dust_cloud)
	dust_cloud.scale *= world_item.scale
	dust_cloud.global_position = world_item.global_position
	await Task.delay(0.1)
