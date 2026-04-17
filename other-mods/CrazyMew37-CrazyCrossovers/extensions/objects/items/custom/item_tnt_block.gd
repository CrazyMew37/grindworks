extends ItemScript

var player: Player:
	get: return Util.get_player()

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_battle_started.connect(on_round_start)

func on_round_start(manager: BattleManager) -> void:
	await get_tree().process_frame
	var new_regen := load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/status_effects/status_effect_aftershock_bomb.tres").duplicate(true)
	new_regen.description = "Deals %d damage every round" % roundi(Util.get_player().stats.max_hp * 0.05)
	new_regen.amount = roundi(Util.get_player().stats.max_hp * 0.05)
	new_regen.target = player
	manager.add_status_effect(new_regen)
	BattleService.s_refresh_statuses.emit()
