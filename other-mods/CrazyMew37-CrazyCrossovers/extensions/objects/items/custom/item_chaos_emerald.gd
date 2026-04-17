extends ItemScriptActive

const STAT_BOOST_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")
const SFX := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/chaosemeraldpowerup.ogg")
const ROUNDS := 1

const ALL_STATS_UP_STATS := {
	'damage': 0.2,
	'luck': 0.2,
	'defense': 0.2,
	'evasiveness': 0.2,
	'crit_mult': 0.2
}

func use() -> void:
	var player := Util.get_player()
	
	AudioManager.play_sound(SFX)
	for stat: String in ALL_STATS_UP_STATS.keys():
		if stat == "crit_mult":
			var stat_boost := load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/status_effects/status_effect_stat_boost_crit.tres").duplicate(true)
			stat_boost.quality = StatusEffect.EffectQuality.POSITIVE
			stat_boost.stat = stat
			stat_boost.boost = randf_range(0.15,0.30)
			stat_boost.rounds = ROUNDS
			stat_boost.target = player
			BattleService.ongoing_battle.add_status_effect(stat_boost)
		else:	
			var stat_boost := STAT_BOOST_REFERENCE.duplicate(true)
			stat_boost.quality = StatusEffect.EffectQuality.POSITIVE
			stat_boost.stat = stat
			stat_boost.boost = randf_range(0.15,0.30)
			stat_boost.rounds = ROUNDS
			stat_boost.target = player
			BattleService.ongoing_battle.add_status_effect(stat_boost)
	BattleService.s_refresh_statuses.emit()
