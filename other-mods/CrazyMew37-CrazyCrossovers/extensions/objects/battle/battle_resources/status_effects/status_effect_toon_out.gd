@tool
extends StatusEffect

var defense_boost := 0.1
var defense_total := 0.0

func apply() -> void:
	on_battle_start()
	target.stats.hp_changed.connect(on_hp_changed)
	manager.s_round_ended.connect(on_round_end)

func on_battle_start() -> void:
	if Util.on_easy_floor():
		defense_boost = 0.05
	on_round_end()

func on_hp_changed(hp: int) -> void:
	if hp > 0:
		defense_total += defense_boost
		var battle_stats: BattleStats = manager.battle_stats[target]
		battle_stats.set("defense",battle_stats.get("defense") + defense_boost)
		print("New defense (Toon Out): ",battle_stats.get("defense"))

func on_round_end() -> void:
	var defense_total_rounded = (snapped(defense_total, 0.001) * 100)
	description = "Gains a +{0}% Defense Boost every time they take damage.\nCurrent Defense Boost: +{1}%".format(["5" if Util.on_easy_floor() else "10", defense_total_rounded])
