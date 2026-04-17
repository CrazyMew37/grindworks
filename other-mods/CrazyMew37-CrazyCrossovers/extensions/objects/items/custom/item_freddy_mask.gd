extends ItemScriptActive


func use() -> void:
	AudioManager.play_sound(load('res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/FreddyMask.ogg'))
	for cog in BattleService.ongoing_battle.cogs:
		apply_stat_boost(cog)
	BattleService.ongoing_battle.battle_ui.cog_panels.reset(0)
	BattleService.ongoing_battle.battle_ui.cog_panels.assign_cogs(BattleService.ongoing_battle.cogs)
	Util.get_player().boost_queue.queue_text("Mask on!", Color(0.87, 0.65, 0.40))
	# WAS THAT THE COLOR OF 87?! -cm37

func apply_stat_boost(cog: Cog) -> void:
	var stat_boost: StatBoost = load('res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres').duplicate(true)
	stat_boost.rounds = 1
	stat_boost.stat = 'accuracy'
	stat_boost.boost = -0.75
	stat_boost.quality = StatusEffect.EffectQuality.NEGATIVE
	stat_boost.target = cog
	BattleService.ongoing_battle.add_status_effect(stat_boost)
	BattleService.s_refresh_statuses.emit()
