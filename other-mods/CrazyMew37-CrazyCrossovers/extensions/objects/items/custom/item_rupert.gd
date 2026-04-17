extends ItemScript

var player: Player:
	get: return Util.get_player()

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_round_ended.connect(on_round_end)

func on_round_end(manager: BattleManager) -> void:
	Util.get_player().stats.damage += 0.01
	Util.get_player().stats.luck += 0.01
	Util.get_player().stats.defense -= 0.01
	Util.get_player().stats.evasiveness -= 0.01
	manager.battle_stats[player].set("damage", manager.battle_stats[player].get("damage") + 0.01)
	manager.battle_stats[player].set("luck", manager.battle_stats[player].get("luck") + 0.01)
	manager.battle_stats[player].set("evasiveness", manager.battle_stats[player].get("evasiveness") - 0.01)
	manager.battle_stats[player].set("defense", manager.battle_stats[player].get("defense") - 0.01)
