extends ItemScript

const BOOST_AMT := 0.15
const BOOST_STATS: Array[String] = ['damage', 'defense', 'evasiveness', 'luck', 'speed']
var multiplier_up := StatMultiplier.new()
var multiplier_down := StatMultiplier.new()

func on_collect(_item: Item, _object: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func on_item_removed() -> void:
	Util.get_player().stats.multipliers.erase(multiplier_up)
	Util.get_player().stats.multipliers.erase(multiplier_down)

func setup() -> void:
	if not Util.get_player():
		await Util.s_player_assigned
	var player := Util.get_player()
	player.stats.s_damage_changed.connect(on_money_changed)
	player.stats.s_defense_changed.connect(on_money_changed)
	player.stats.s_evasiveness_changed.connect(on_money_changed)
	player.stats.s_luck_changed.connect(on_money_changed)
	player.stats.s_speed_changed.connect(on_money_changed)
	create_multipliers()

func create_multipliers() -> void:
	multiplier_up.stat = get_lowest_stat()
	multiplier_down.stat = get_highest_stat()
	multiplier_up.additive = true
	multiplier_up.amount = BOOST_AMT
	Util.get_player().stats.multipliers.append(multiplier_up)
	multiplier_down.additive = true
	multiplier_down.amount = -BOOST_AMT
	Util.get_player().stats.multipliers.append(multiplier_down)

func get_lowest_stat() -> String:
	var stats := Util.get_player().stats
	var current_stats := [stats.damage, stats.defense, stats.evasiveness, stats.luck, stats.speed]
	return BOOST_STATS[current_stats.find(current_stats.min())]

func get_highest_stat() -> String:
	var stats := Util.get_player().stats
	var current_stats := [stats.damage, stats.defense, stats.evasiveness, stats.luck, stats.speed]
	return BOOST_STATS[current_stats.find(current_stats.max())]

## Sync multipliers to current stat amount
func on_money_changed(_amount: int) -> void:
	Util.get_player().stats.multipliers.erase(multiplier_up)
	Util.get_player().stats.multipliers.erase(multiplier_down)
	create_multipliers()
