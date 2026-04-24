extends ItemCharSetup

var multipliers: Array[StatMultiplier]

func on_collect(_item: Item, _model) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	Util.get_player().stats.s_luck_changed.connect(on_luck_change)
	create_multiplier()
	on_luck_change(Util.get_player().stats.luck)

func create_multiplier() -> void:
	var mult := StatMultiplier.new()
	mult.stat = 'damage'
	mult.amount = 0.0
	mult.additive = true
	multipliers.append(mult)
	Util.get_player().stats.multipliers.append(mult)

func on_luck_change(_amount: int) -> void:
	for mult: StatMultiplier in multipliers:
		if Util.get_player().stats.luck > 1.0:
			mult.amount = (Util.get_player().stats.luck - 1.0)
		else:
			mult.amount = 0.0
