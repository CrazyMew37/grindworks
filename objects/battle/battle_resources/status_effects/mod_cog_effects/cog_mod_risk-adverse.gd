@tool
extends StatusEffect

func apply() -> void:
	await Task.delay(0.25)
	var battle_stats: BattleStats = manager.battle_stats[target]
	battle_stats.set('damage',battle_stats.get('damage') * 0.75)
	battle_stats.set('defense',battle_stats.get('defense') * 2.0)
