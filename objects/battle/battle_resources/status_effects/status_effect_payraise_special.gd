@tool
extends StatusEffectDiminishingReturns

func get_description() -> String:
	return "x1.5 damage and defense
Defeat this cog to gain 5 jellybeans"

func apply() -> void:
	target.stats.damage *= 1.5
	manager.battle_stats[target].defense *= 1.5
