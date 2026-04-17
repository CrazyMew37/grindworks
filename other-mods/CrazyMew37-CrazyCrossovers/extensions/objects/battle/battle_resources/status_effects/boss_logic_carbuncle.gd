@tool
extends StatusEffect

var carbuncle: Cog:
	get: return target

# Called by battle manager on initial application
func apply():
	rounds = -1
	manager.s_round_started.connect(round_started)

func cleanup() -> void:
	if manager.s_round_started.is_connected(round_started):
		manager.s_round_started.disconnect(round_started)

var CURRY_CURE: CogAttack = preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/misc_movies/curry_cure.tres")

func round_started(_actions: Array[BattleAction]) -> void:
	# Curry Cure: Used only on Round 1 on higher floors
	if manager.current_round == 1 && not Util.on_easy_floor():
		curry_cure()

func curry_cure() -> void:
	var attack: CogAttack = CURRY_CURE.duplicate(true)
	
	var possible_targets: Array = carbuncle.get_targets(attack.target_type).duplicate(true)
	
	# Oops! No targets.
	if len(possible_targets) == 0:
		return
	
	attack.user = carbuncle
	
	var highest_level_cog = possible_targets[0]
	# Pick out the lowest level Cog in our roster. If Carbuncle is by himself HE'LL HEAL HIMSELF DOUBLE!
	for i in range(1,possible_targets.size()):
		var current_cog = possible_targets[i]
		if highest_level_cog.level < current_cog.level:
			highest_level_cog = current_cog
	
	attack.targets = [highest_level_cog]
	
	manager.round_actions.push_front(attack)
