@tool
extends StatusEffect

var mrkrabs: Cog:
	get: return target

# Called by battle manager on initial application
func apply():
	rounds = -1
	manager.s_round_started.connect(round_started)

func cleanup() -> void:
	if manager.s_round_started.is_connected(round_started):
		manager.s_round_started.disconnect(round_started)

func round_started(_actions: Array[BattleAction]) -> void:
	# Penny Penching: Every round, starting on round 1
	penny_pinching()
	# Call Reinforcements: Every 4 rounds, starting on round 1
	if manager.current_round % 4 == 1:
		call_reinforcements()

const REINFORCEMENTS := preload("res://objects/battle/battle_resources/cog_attacks/resources/call_reinforcements.tres")
var penny_pinching_attack: CogAttack = preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/misc_movies/penny_pinching.tres")

func call_reinforcements() -> void:
	if Util.on_easy_floor() and BattleService.ongoing_battle.cogs.size() < 3:
		var action := REINFORCEMENTS.duplicate(true)
		action.user = mrkrabs
		action.cog_amount = (3 - BattleService.ongoing_battle.cogs.size())
		action.targets = [mrkrabs]
		BattleService.ongoing_battle.round_end_actions.append(action)
	elif not Util.on_easy_floor() and BattleService.ongoing_battle.cogs.size() < 4:
		var action := REINFORCEMENTS.duplicate(true)
		action.user = mrkrabs
		action.cog_amount = (4 - BattleService.ongoing_battle.cogs.size())
		action.targets = [mrkrabs]
		BattleService.ongoing_battle.round_end_actions.append(action)
	else:
		return

func penny_pinching() -> void:
	var attack: CogAttack = penny_pinching_attack.duplicate(true)
	
	var possible_targets: Array = mrkrabs.get_targets(attack.target_type).duplicate(true)
	
	# Filter out directors from this pool of targets
	possible_targets = possible_targets.filter(func(x: Cog): return x.dna.is_admin != true)
	
	# Oops! No targets.
	if len(possible_targets) == 0:
		return
	
	attack.user = mrkrabs
	
	var lowest_level_cog = possible_targets[0]
	# Pick out the lowest level Cog in our roster
	for i in range(1,possible_targets.size()):
		var current_cog = possible_targets[i]
		if lowest_level_cog.level > current_cog.level:
			lowest_level_cog = current_cog
	
	attack.targets = [lowest_level_cog]
	
	manager.round_actions.push_front(attack)
