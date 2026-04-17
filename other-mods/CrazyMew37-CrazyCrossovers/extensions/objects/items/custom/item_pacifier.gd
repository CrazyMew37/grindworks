extends ItemScriptActive


func use() -> void:
	AudioManager.play_sound(load('res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/maggiesuck.ogg'))
	for cog in BattleService.ongoing_battle.cogs:
		apply_stat_boost(cog)
	BattleService.ongoing_battle.battle_ui.cog_panels.reset(0)
	BattleService.ongoing_battle.battle_ui.cog_panels.assign_cogs(BattleService.ongoing_battle.cogs)
	Util.get_player().boost_queue.queue_text("Pacified!", Color.CORNFLOWER_BLUE)

func apply_stat_boost(cog: Cog) -> void:
	var stat_boost: StatBoost = load('res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres').duplicate(true)
	stat_boost.rounds = 1
	stat_boost.stat = 'damage'
	stat_boost.boost = -0.35
	stat_boost.quality = StatusEffect.EffectQuality.NEGATIVE
	stat_boost.target = cog
	BattleService.ongoing_battle.add_status_effect(stat_boost)
	var stat_boost2: StatBoost = load('res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres').duplicate(true)
	stat_boost2.rounds = 1
	stat_boost2.stat = 'defense'
	stat_boost2.boost = -0.35
	stat_boost2.quality = StatusEffect.EffectQuality.NEGATIVE
	stat_boost2.target = cog
	BattleService.ongoing_battle.add_status_effect(stat_boost2)
	BattleService.s_refresh_statuses.emit()
