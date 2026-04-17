extends ItemScriptActive

const STAT_BOOST_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")
const SFX := preload("res://audio/sfx/items/big_chomp.ogg")

func use() -> void:
	var player := Util.get_player()
	
	AudioManager.play_sound(SFX)
	player.quick_heal(player.stats.max_hp)
	player.stats.damage -= 0.06
	player.stats.luck -= 0.06
	player.stats.defense -= 0.06
	player.stats.evasiveness -= 0.06
	player.stats.speed -= 0.06
	if BattleService.ongoing_battle:
		BattleService.ongoing_battle.battle_stats[player].set("damage", BattleService.ongoing_battle.battle_stats[player].get("damage") - 0.06)
		BattleService.ongoing_battle.battle_stats[player].set("luck", BattleService.ongoing_battle.battle_stats[player].get("luck") - 0.06)
		BattleService.ongoing_battle.battle_stats[player].set("evasiveness", BattleService.ongoing_battle.battle_stats[player].get("evasiveness") - 0.06)
		BattleService.ongoing_battle.battle_stats[player].set("defense", BattleService.ongoing_battle.battle_stats[player].get("defense") - 0.06)
		BattleService.ongoing_battle.battle_stats[player].set("speed", BattleService.ongoing_battle.battle_stats[player].get("speed") - 0.06)
