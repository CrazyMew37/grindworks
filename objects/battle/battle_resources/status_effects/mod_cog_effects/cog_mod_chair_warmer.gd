@tool
extends StatusEffect

var attack_turn := true

func apply() -> void:
	target.stats.turns += 2
	manager.s_round_started.connect(on_round_started)

func on_round_started(_started) -> void:
	var cog: Cog = target
	if attack_turn == false:
		manager.skip_turn(cog)
	attack_turn = not attack_turn
