@tool
extends StatusEffect

func apply() -> void:
	await Task.delay(0.25)
	var battle_stats: BattleStats = manager.battle_stats[target]
	battle_stats.set('damage',battle_stats.get('damage') * 2.0)
	battle_stats.set('defense',battle_stats.get('defense') * 0.5)
