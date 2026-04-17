@tool
extends StatusEffect

var monika: Cog:
	get: return target

# Called by battle manager on initial application
func apply():
	rounds = -1
	manager.s_round_started.connect(round_started)

func cleanup() -> void:
	if manager.s_round_started.is_connected(round_started):
		manager.s_round_started.disconnect(round_started)

func round_started(_actions: Array[BattleAction]) -> void:
	# Delete. Executes on every round/every other round.
	if Util.on_easy_floor():
		if manager.current_round % 2 == 1:
			delete()
	else:
		if manager.current_round % 1 == 0:
			delete()

var delete_attack := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/misc_movies/delete.tres")

func delete():
	var attack: CogAttack = delete_attack.duplicate(true)
	
	attack.user = monika
	
	var possible_targets: Array[Cog] = monika.get_targets(attack.target_type).duplicate(true)
	# Filter out directors from this pool of targets
	possible_targets = possible_targets.filter(func(x: Cog) -> bool: return x.dna.cog_name != 'Monika')
	
	# Oh no! No targets. guess we suck.
	if len(possible_targets) == 0:
		return
	
	var highest_hp_mult_cog = possible_targets[0]
	# Pick out the highest level Cog in our roster
	for i in range(1,possible_targets.size()):
		var current_cog = possible_targets[i]
		if highest_hp_mult_cog.health_mod < current_cog.health_mod:
			highest_hp_mult_cog = current_cog
	
	attack.targets = [highest_hp_mult_cog]
	
	manager.round_end_actions.append(attack)
