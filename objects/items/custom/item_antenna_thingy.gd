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
	player.stats.s_defense_changed.connect(on_defense_changed)
	create_multiplier()
	on_defense_changed(player.stats.defense)

func on_item_removed() -> void:
	Util.get_player().stats.multipliers.erase(multiplier)

## Sync multipliers to current speed amount
func on_defense_changed(defense: float) -> void:
	multiplier.amount = maxf(0.0, (defense) * 0.15)

func create_multiplier() -> void:
	multiplier = StatMultiplier.new()
	multiplier.stat = 'evasiveness'
	multiplier.amount = maxf(0.0, (Util.get_player().stats.defense) * 0.15)
	multiplier.additive = true
	Util.get_player().stats.multipliers.append(multiplier)
