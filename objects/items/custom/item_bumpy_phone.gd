extends ItemScriptActive

const WORLD_ITEM = preload("res://objects/items/world_item/world_item.tscn")
const PARTNER_TOON = preload("res://objects/partnertoon/roaming_toon/partner_toon.tres")
const DOODLE = preload("res://objects/items/resources/passive/doodle.tres")
const SFX := preload('res://audio/sfx/battle/cogs/attacks/SA_hangup.ogg')

func use() -> void:
	AudioManager.play_sound(SFX)
	# Makes this work in debug rooms
	var zone
	if is_instance_valid(Util.floor_manager):
		zone = Util.floor_manager.get_current_room()
	else:
		zone = SceneLoader
	
	# OoOoooOooO look away from position calculations oOoOoOoo
	var rel_basis = Util.get_player().toon.global_basis
	var rel_pos = Util.get_player().global_position + (rel_basis * Vector3(0, .2, 3))
	var raycast_check = Util.get_player().get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(Util.get_player().global_position, rel_pos, 0b0001))
	if raycast_check:
		rel_pos = raycast_check.position - (rel_basis * Vector3(0,0,.5))
	
	var item_count = RNG.channel(RNG.ChannelAccessoryTrunkItems).randi_range(2, 4)
	var offset_amount = 2.5
	if item_count % 2 != 0:
		offset_amount = 2
	var side_dist = rel_basis * Vector3(item_count / offset_amount, 0, 0)
	rel_pos += side_dist
	
	var right_side_raycast = Util.get_player().get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(rel_pos, rel_pos - (side_dist * 2), 0b0001))
	var left_side_raycast = Util.get_player().get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(rel_pos - side_dist, rel_pos, 0b0001))
	if right_side_raycast:
		var dist = rel_pos.distance_to(right_side_raycast.position)
		rel_pos += (rel_basis * Vector3((item_count - dist), 0, 0))
	if left_side_raycast:
		rel_pos = left_side_raycast.position - (rel_basis * Vector3(.5, 0, 0))
	
	var _item = WORLD_ITEM.instantiate()
	_item.override_replacement_rolls = true
	_item.item = PARTNER_TOON
	zone.add_child(_item)
	_item.global_position = rel_pos + (rel_basis * Vector3(-1, 0.25, 0))
	var dust_cloud = Globals.DUST_CLOUD.instantiate()
	zone.add_child(dust_cloud)
	dust_cloud.scale *= _item.scale
	dust_cloud.global_position = _item.global_position
	await Task.delay(0.1)
	
	var _item2 = WORLD_ITEM.instantiate()
	_item2.override_replacement_rolls = true
	_item2.item = DOODLE
	zone.add_child(_item2)
	_item2.global_position = rel_pos + (rel_basis * Vector3(-2, 0.25, 0))
	var dust_cloud2 = Globals.DUST_CLOUD.instantiate()
	zone.add_child(dust_cloud2)
	dust_cloud2.scale *= _item2.scale
	dust_cloud2.global_position = _item2.global_position
	queue_free()
