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
	var new_regen := load("res://objects/battle/battle_resources/status_effects/resources/status_effect_regeneration.tres").duplicate(true)
	new_regen.status_name = "Krusty Goodness"
	new_regen.icon = load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pocket_prank_icons/krabbypatty.png")
	new_regen.icon_scale = 0.8
	new_regen.description = "You will heal %s% laff every round" % roundi(Util.get_player().stats.max_hp * 0.04 * Util.get_player().stats.healing_effectiveness)
	new_regen.rounds = -1
	new_regen.instant_effect = false
	new_regen.amount = roundi(Util.get_player().stats.max_hp * 0.04 * Util.get_player().stats.healing_effectiveness)
	new_regen.target = player
	manager.add_status_effect(new_regen)
	BattleService.s_refresh_statuses.emit()
