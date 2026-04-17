extends ItemScriptActive

const STAT_BOOST_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")
const SFX := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/abslingshot.ogg")
const ROUNDS := 2

func use() -> void:
	var player := Util.get_player()
	
	AudioManager.play_sound(SFX)
	var stat_boost := load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/status_effects/status_effect_stat_boost_crit.tres").duplicate(true)
	stat_boost.quality = StatusEffect.EffectQuality.POSITIVE
	stat_boost.stat = "crit_mult"
	stat_boost.boost = 0.25
	stat_boost.rounds = ROUNDS
	stat_boost.target = player
	BattleService.ongoing_battle.add_status_effect(stat_boost)
	var stat_boost2 := STAT_BOOST_REFERENCE.duplicate(true)
	stat_boost2.quality = StatusEffect.EffectQuality.POSITIVE
	stat_boost2.stat = "luck"
	stat_boost2.boost = 0.15
	stat_boost2.rounds = ROUNDS
	stat_boost2.target = player
	BattleService.ongoing_battle.add_status_effect(stat_boost2)
	BattleService.s_refresh_statuses.emit()
