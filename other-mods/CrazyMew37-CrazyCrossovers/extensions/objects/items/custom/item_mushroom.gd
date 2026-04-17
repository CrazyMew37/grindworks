extends ItemScript

var player: Player
var dmg_mult: StatMultiplier


func on_collect(_item: Item, _object: Node3D) -> void:
	setup(_item)

func on_load(_item: Item) -> void:
	setup(_item)

func on_item_removed() -> void:
	Util.get_player().stats.multipliers.erase(dmg_mult)

func setup(_item: Item) -> void:
	if not Util.get_player():
		await Util.s_player_assigned
	player = Util.get_player()

	create_multiplier()
	on_hp_changed()
	player.stats.hp_changed.connect(on_hp_changed.unbind(1))
	player.stats.max_hp_changed.connect(on_hp_changed.unbind(1))

func create_multiplier() -> void:
	dmg_mult = StatMultiplier.new()
	dmg_mult.stat = "damage"
	if player.stats.hp == player.stats.max_hp:
		dmg_mult.amount = 0.2
	else:
		dmg_mult.amount = 0.0
	dmg_mult.additive = true
	Util.get_player().stats.multipliers.append(dmg_mult)

func on_hp_changed() -> void:
	if player.stats.hp == player.stats.max_hp:
		dmg_mult.amount = 0.2
	else:
		dmg_mult.amount = 0.0
