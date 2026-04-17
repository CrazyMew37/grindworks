extends ItemScript

# This item runs a x second battle timer on every round
# And does some silly schenanigans

## Battle Timer created by Util
var timer: GameTimer

var STAT_BOOST := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/status_effects/status_effect_microgame.tres")

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()
	Util.get_player().stats.battle_timers.append(10)
	for track in Util.get_player().stats.gag_balance.keys():
		Util.get_player().stats.gag_regeneration[track] += 1

func on_item_removed() -> void:
	Util.get_player().stats.battle_timers.erase(10)
	for track in Util.get_player().stats.gag_balance.keys():
		Util.get_player().stats.gag_regeneration[track] -= 1

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_battle_started.connect(on_battle_start)

func on_battle_start(manager: BattleManager) -> void:
	await manager.s_ui_initialized
	var stat_boost := STAT_BOOST.duplicate(true)
	stat_boost.target = Util.get_player()
	BattleService.ongoing_battle.add_status_effect(stat_boost)
