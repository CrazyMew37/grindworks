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
	player.stats.s_speed_changed.connect(on_speed_changed)
	create_multiplier()
	on_speed_changed(player.stats.speed)

func on_item_removed() -> void:
	Util.get_player().stats.multipliers.erase(multiplier)

## Sync multipliers to current speed amount
func on_speed_changed(speed: float) -> void:
	# to avoid some divide by zero schenanigans
	if speed < 1.0:
		multiplier.amount = 0.2 * ((speed - 1.0) ** 0.5)
	else:
		multiplier.amount = 0.0

func create_multiplier() -> void:
	multiplier = StatMultiplier.new()
	multiplier.stat = 'crit_mult'
	# to avoid some divide by zero schenanigans
	if Util.get_player().stats.speed < 1.0:
		multiplier.amount = 0.2 * ((Util.get_player().stats.speed - 1.0) ** 0.5)
	else:
		multiplier.amount = 0.0
	multiplier.additive = true
	Util.get_player().stats.multipliers.append(multiplier)
