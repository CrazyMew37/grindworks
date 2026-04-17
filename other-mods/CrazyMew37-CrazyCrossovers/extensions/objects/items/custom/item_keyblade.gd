extends ItemScriptActive

const DebugPrint := true

const POOL_BATTLE_CLEARS := "res://objects/items/pools/battle_clears.tres"
const POOL_REWARDS := "res://objects/items/pools/rewards.tres"
const POOL_PROGRESSIVES := "res://objects/items/pools/progressives.tres"
const POOL_SPECIAL := "res://objects/items/pools/special_items.tres"

func validate_use() -> bool:
	return not get_items().is_empty()

func use() -> void:
	AudioManager.play_sound(load("res://audio/sfx/misc/MG_pairing_match_bonus_both.ogg"))
	Util.get_player().boost_queue.queue_text("Chests Upgraded!", Color.GOLD)
	var world_items := get_items()
	
	for chest in world_items:
		if chest.scripted_progression:
			return
		if chest.override_item:
			return
		if chest.unopenable:
			return

		var _rng: ToonNumGen = RNG.channel(RNG.ChannelPhilosophersStoneRolls)
		if chest.get_current_texture() != TreasureChest.BOSS_TEXTURE:
			# Bronze -> Silver
			if chest.item_pool.resource_path == POOL_BATTLE_CLEARS:
				make_upgradeable(chest, upgrade_silver)
			# Silver -> Gold
			if chest.item_pool.resource_path == POOL_PROGRESSIVES:
				make_upgradeable(chest, upgrade_gold)
			# Gold -> Special
			if chest.item_pool.resource_path == POOL_REWARDS:
				make_upgradeable(chest, upgrade_special)

func get_items() -> Array[TreasureChest]:
	var items: Array[TreasureChest] = []
	# Find our World Items
	var root: Node
	if Util.floor_manager:
		root = Util.floor_manager.get_current_room()
	else:
		root = SceneLoader.current_scene
	var world_items: Array[Node] = NodeGlobals.get_children_of_type(root, TreasureChest, true)
	items.assign(world_items)
	return items

func make_upgradeable(chest: TreasureChest, upgrade_func: Callable) -> void:
	var area := Area3D.new()
	area.collision_layer = 0
	area.collision_mask = 0
	area.set_collision_layer_value(1, true)
	area.set_collision_mask_value(2, true)
	var cs3d := CollisionShape3D.new()
	var _sphere := SphereShape3D.new()
	_sphere.radius = 10000.0
	cs3d.shape = _sphere
	area.add_child(cs3d)
	area.body_entered.connect(_entered_upgrade_coll.bind(chest, upgrade_func), CONNECT_ONE_SHOT)
	chest.add_child(area)

func _entered_upgrade_coll(body: Node3D, chest: TreasureChest, upgrade_func: Callable) -> void:
	if body is Player:
		await get_tree().process_frame
		await get_tree().process_frame
		upgrade_func.call(chest)

func upgrade_silver(chest: TreasureChest) -> void:
	if chest.item_pool.resource_path != POOL_BATTLE_CLEARS:
		# Filter out any stragglers that aren't actually silver chests
		return
	if chest.get_current_texture() == TreasureChest.BOSS_TEXTURE:
		return
	if not is_instance_valid(chest):
		return

	chest.item_pool = ItemService.get_centralized_pool(load(POOL_PROGRESSIVES))
	if RNG.channel(RNG.ChannelChestRolls).randf() < chest.REWARD_OVERRIDE_CHANCE:
		chest.override_replacement_rolls = true
	chest.show_dust_cloud()

func upgrade_gold(chest: TreasureChest) -> void:
	if chest.item_pool.resource_path != POOL_PROGRESSIVES:
		# Filter out any stragglers that aren't actually silver chests
		return
	if chest.get_current_texture() == TreasureChest.BOSS_TEXTURE:
		return
	if not is_instance_valid(chest):
		return

	chest.item_pool = ItemService.get_centralized_pool(load(POOL_REWARDS))
	if RNG.channel(RNG.ChannelChestRolls).randf() < chest.REWARD_OVERRIDE_CHANCE:
		chest.override_replacement_rolls = true
	chest.show_dust_cloud()

func upgrade_special(chest: TreasureChest) -> void:
	if chest.item_pool.resource_path != POOL_REWARDS:
		# Filter out any stragglers that aren't actually gold chests
		return
	if chest.get_current_texture() == TreasureChest.BOSS_TEXTURE:
		return
	if not is_instance_valid(chest):
		return

	chest.item_pool = ItemService.get_centralized_pool(load(POOL_SPECIAL))
	chest.override_replacement_rolls = true
	chest.show_dust_cloud()
