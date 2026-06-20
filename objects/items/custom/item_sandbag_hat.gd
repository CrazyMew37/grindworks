extends ItemScript

var multiplier: StatMultiplier

func on_collect(_item: Item, _object: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	if not Util.get_player():
		await Util.s_player_assigned
	var player := Util.get_player()
	player.stats.s_luck_changed.connect(on_luck_changed)
	create_multiplier()
	on_luck_changed(player.stats.luck)

func on_item_removed() -> void:
	Util.get_player().stats.multipliers.erase(multiplier)

## Sync multipliers to current speed amount
func on_luck_changed(luck: float) -> void:
	if luck > 1.0:
		multiplier.amount = 0.2 * ((luck - 1.0) ** 0.5)
	else:
		multiplier.amount = 0.0

func create_multiplier() -> void:
	multiplier = StatMultiplier.new()
	multiplier.stat = 'crit_mult'
	if Util.get_player().stats.luck > 1.0:
		multiplier.amount = 0.2 * ((Util.get_player().stats.luck - 1.0) ** 0.5)
	else:
		multiplier.amount = 0.0
	multiplier.additive = true
	Util.get_player().stats.multipliers.append(multiplier)
