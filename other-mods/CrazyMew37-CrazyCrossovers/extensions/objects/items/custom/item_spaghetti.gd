extends ItemScriptActive

const STAT_BOOST_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")
const SFX := preload("res://audio/sfx/items/big_chomp.ogg")
const ROUNDS := 1

const ALL_STATS_UP_STATS := {
	'damage': -0.15,
	'luck': -0.15,
	'defense': -0.15,
	'evasiveness': -0.15
}

func use() -> void:
	var player := Util.get_player()
	
	AudioManager.play_sound(SFX)
	player.quick_heal(ceili(player.stats.max_hp * 0.5))
	if BattleService.ongoing_battle:
		for stat: String in ALL_STATS_UP_STATS.keys():
			var stat_boost := STAT_BOOST_REFERENCE.duplicate(true)
			stat_boost.quality = StatusEffect.EffectQuality.NEGATIVE
			stat_boost.stat = stat
			stat_boost.boost = -0.15
			stat_boost.rounds = ROUNDS
			stat_boost.target = player
			BattleService.ongoing_battle.add_status_effect(stat_boost)
		BattleService.s_refresh_statuses.emit()
