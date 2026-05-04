@tool
extends StatusEffect

func apply() -> void:
	await Task.delay(0.25)
	var battle_stats: BattleStats = manager.battle_stats[target]
	battle_stats.set('damage',battle_stats.get('damage') * Util.get_player().stats.get_stat('damage'))
	description = "This cog mimics your initial damage stat, therefore gaining a x{0} damage multiplier.".format([snapped(Util.get_player().stats.get_stat('damage'), 0.01)])
