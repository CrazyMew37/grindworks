@tool
extends StatusEffect

var bowser: Cog:
	get: return target
var player = Util.get_player()

# Called by battle manager on initial application
func apply():
	rounds = -1
	manager.s_round_started.connect(round_started)

func cleanup() -> void:
	if manager.s_round_started.is_connected(round_started):
		manager.s_round_started.disconnect(round_started)

func round_started(_actions: Array[BattleAction]) -> void:
	# Bowser Broil: Every round, starting on round 1
	bowser_broil()
	# Call Reinforcements: some may be horrified at these conditions
	if manager.current_round == 1 and Util.on_easy_floor() and BattleService.ongoing_battle.cogs.size() < 4:
		call_reinforcements(2)
	elif manager.current_round == 1 and not Util.on_easy_floor() and BattleService.ongoing_battle.cogs.size() < 4:
		call_reinforcements(3)
	elif Util.on_easy_floor() and manager.current_round % 2 == 1 and manager.current_round > 1 and BattleService.ongoing_battle.cogs.size() < 4:
		call_reinforcements(1)
	elif not Util.on_easy_floor() and manager.current_round > 1 and BattleService.ongoing_battle.cogs.size() < 4:
		call_reinforcements(1)

const REINFORCEMENTS := preload("res://objects/battle/battle_resources/cog_attacks/resources/call_reinforcements.tres")
const BROIL_BURN := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/misc_movies/bowser_broil.tres")

func bowser_broil() -> void:
	var action := BROIL_BURN.duplicate(true)
	action.user = bowser
	action.targets = [player]
	BattleService.ongoing_battle.round_end_actions.append(action)

func call_reinforcements(summons: int) -> void:
	var action := REINFORCEMENTS.duplicate(true)
	action.user = bowser
	action.cog_amount = summons
	action.targets = [bowser]
	BattleService.ongoing_battle.round_end_actions.append(action)
