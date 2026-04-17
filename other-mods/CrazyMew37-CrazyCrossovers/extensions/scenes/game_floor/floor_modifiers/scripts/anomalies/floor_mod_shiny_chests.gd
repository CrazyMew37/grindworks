extends FloorModifier

const DebugPrint := true

const SilverUpgradeChance := 0.15
const GoldUpgradeChance := 0.1
const SpecialUpgradeChance := 0.05

const POOL_REWARDS := "res://objects/items/pools/rewards.tres"
const POOL_BATTLE_CLEARS := "res://objects/items/pools/battle_clears.tres"
const POOL_PROGRESSIVES := "res://objects/items/pools/progressives.tres"
const POOL_SPECIAL := "res://objects/items/pools/special_items.tres"

func modify_floor() -> void:
	Globals.s_chest_spawned.connect(_chest_spawned)

func _chest_spawned(chest: TreasureChest) -> void:
	if chest.scripted_progression:
		return
	if chest.override_item:
		return
	if chest.unopenable:
		return

	var _rng: ToonNumGen = RNG.channel(RNG.ChannelPhilosophersStoneRolls)
	if chest.get_current_texture() != TreasureChest.BOSS_TEXTURE:
		# Silver -> Gold
		if chest.item_pool.resource_path == POOL_BATTLE_CLEARS and silver_upgrade_roll():
			make_upgradeable(chest, upgrade_silver)
		# Silver -> Gold
		if chest.item_pool.resource_path == POOL_PROGRESSIVES and gold_upgrade_roll():
			make_upgradeable(chest, upgrade_gold)
		# Gold -> Special
		if chest.item_pool.resource_path == POOL_REWARDS and special_upgrade_roll():
			make_upgradeable(chest, upgrade_special)

func silver_upgrade_roll() -> bool:
	var _roll := RNG.channel(RNG.ChannelPhilosophersStoneRolls).randf()
	if DebugPrint: print("SC - Silver Roll: Needed %s or lower, got %s" % [SilverUpgradeChance, _roll])
	return _roll < SilverUpgradeChance

func gold_upgrade_roll() -> bool:
	var _roll := RNG.channel(RNG.ChannelPhilosophersStoneRolls).randf()
	if DebugPrint: print("SC - Gold Roll: Needed %s or lower, got %s" % [GoldUpgradeChance, _roll])
	return _roll < GoldUpgradeChance

func special_upgrade_roll() -> bool:
	var _roll := RNG.channel(RNG.ChannelPhilosophersStoneRolls).randf()
	if DebugPrint: print("SC - Special Roll: Needed %s or lower, got %s" % [SpecialUpgradeChance, _roll])
	return _roll < SpecialUpgradeChance

func make_upgradeable(chest: TreasureChest, upgrade_func: Callable) -> void:
	var area := Area3D.new()
	area.collision_layer = 0
	area.collision_mask = 0
	area.set_collision_layer_value(1, true)
	area.set_collision_mask_value(2, true)
	var cs3d := CollisionShape3D.new()
	var _sphere := SphereShape3D.new()
	_sphere.radius = 6.0
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
		# Filter out any stragglers that aren't actually bronze chests
		return
	if chest.get_current_texture() == TreasureChest.BOSS_TEXTURE:
		return
	if not is_instance_valid(chest):
		return

	chest.item_pool = ItemService.get_centralized_pool(load(POOL_PROGRESSIVES))
	if RNG.channel(RNG.ChannelChestRolls).randf() < chest.REWARD_OVERRIDE_CHANCE:
		chest.override_replacement_rolls = true
	chest.show_dust_cloud()
	Util.get_player().boost_queue.queue_text("Silver Upgrade!", Color.LIGHT_STEEL_BLUE)
	AudioManager.play_sound(load("res://audio/sfx/battle/gags/toonup/sparkly.ogg"))

	if gold_upgrade_roll():
		# If bro is really lucky
		await get_tree().process_frame
		upgrade_gold(chest)

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
	Util.get_player().boost_queue.queue_text("Gold Upgrade!", Color.GOLDENROD)
	AudioManager.play_sound(load("res://audio/sfx/misc/MG_pairing_match_bonus_both.ogg"))

	if special_upgrade_roll():
		# If bro is really lucky
		await get_tree().process_frame
		upgrade_special(chest)

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
	Util.get_player().boost_queue.queue_text("Special Upgrade!", Color.AQUA)
	AudioManager.play_sound(load("res://audio/sfx/misc/Holy_Mackerel.ogg"))

func get_mod_name() -> String:
	return "Shiny Chests"

func get_mod_icon() -> Texture2D:
	return load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pause/shinychests.png")

func get_description() -> String:
	return "Bronze Chests have a 15% chance to upgrade into Silver Chests, Silver Chests have a 10% chance to upgrade into Gold Chests, and Gold Chests have a 5% chance to upgrade into Special Chests"

func get_mod_quality() -> ModType:
	return ModType.POSITIVE
