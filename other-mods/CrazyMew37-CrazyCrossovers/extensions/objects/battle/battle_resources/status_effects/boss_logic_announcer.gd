@tool
extends StatusEffect

var announcer: Cog:
	get: return target

# Called by battle manager on initial application
func apply():
	await manager.s_ui_initialized
	apply_contests()
	rounds = -1
	manager.s_round_started.connect(round_started)
	manager.s_round_ended.connect(round_ended)

func cleanup() -> void:
	if manager.s_round_started.is_connected(round_started):
		manager.s_round_started.disconnect(round_started)
	if manager.s_round_ended.is_connected(round_ended):
		manager.s_round_ended.disconnect(round_ended)

func round_started(_actions: Array[BattleAction]) -> void:
	# Call Reinforcements: Every 2/3 rounds, starting on round 2/3
	if not Util.on_easy_floor() and manager.current_round % 2 == 0:
		call_reinforcements()
	elif Util.on_easy_floor() and manager.current_round % 3 == 0:
		call_reinforcements()

func round_ended() -> void:
	apply_contests()

const REINFORCEMENTS := preload("res://objects/battle/battle_resources/cog_attacks/resources/call_reinforcements.tres")
var gag_contest: StatusEffect = preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/status_effects/status_effect_gag_challenge.tres")
var cog_contest: StatusEffect = preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/status_effects/status_effect_target_challenge.tres")

func call_reinforcements() -> void:
	if BattleService.ongoing_battle.cogs.size() < 4:
		var action := REINFORCEMENTS.duplicate(true)
		action.user = announcer
		action.cog_amount = 1
		action.targets = [announcer]
		BattleService.ongoing_battle.round_end_actions.append(action)
	else:
		return

func apply_contests() -> void:
	var con_target := cog_contest.duplicate(true)
	con_target.target = BattleService.ongoing_battle.cogs.pick_random()
	BattleService.ongoing_battle.add_status_effect(con_target)
	if not Util.on_easy_floor():
		var con_gag := gag_contest.duplicate(true)
		con_gag.target = Util.get_player()
		BattleService.ongoing_battle.add_status_effect(con_gag)
	await manager.sleep(0.01)
	BattleService.ongoing_battle.battle_ui.reset()
	BattleService.ongoing_battle.battle_ui.cog_panels.reset(0)
	BattleService.ongoing_battle.battle_ui.cog_panels.assign_cogs(BattleService.ongoing_battle.cogs)
