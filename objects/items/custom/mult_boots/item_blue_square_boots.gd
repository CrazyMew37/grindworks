extends ItemScript

const BOOST_STATS :={
	'defense': 0.25
}
var multipliers: Array[StatMultiplier]


func on_collect(_item: Item, _object: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func on_item_removed() -> void:
	for multiplier in multipliers:
		Util.get_player().stats.multipliers.erase(multiplier)

func setup() -> void:
	for stat in BOOST_STATS.keys():
		var mult := StatMultiplier.new()
		mult.stat = stat
		mult.amount = BOOST_STATS[stat]
		mult.additive = false
		multipliers.append(mult)
		Util.get_player().stats.multipliers.append(mult)
