extends FloorModifier

const RANDOM_EFFECTS := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")

func modify_floor() -> void:
	BattleService.s_battle_started.connect(on_battle_start)
	BattleService.s_round_ended.connect(on_round_end)

func on_battle_start(battle: BattleManager) -> void:
	for cog in battle.cogs:
		apply_effect(cog)
	battle.s_participant_joined.connect(func(participant):
		if participant is Cog:
			apply_effect(participant)
	)
	
	await Util.s_process_frame
	
	BattleService.s_refresh_statuses.emit()
	BattleService.ongoing_battle.battle_ui.cog_panels.reset(0)
	BattleService.ongoing_battle.battle_ui.cog_panels.assign_cogs(BattleService.ongoing_battle.cogs)

func on_round_end(battle: BattleManager) -> void:
	for cog in battle.cogs:
		apply_effect(cog)
	
	await Util.s_process_frame
	
	BattleService.s_refresh_statuses.emit()
	BattleService.ongoing_battle.battle_ui.cog_panels.reset(0)
	BattleService.ongoing_battle.battle_ui.cog_panels.assign_cogs(BattleService.ongoing_battle.cogs)

func apply_effect(cog: Cog) -> void:
	var effect: StatusEffect = RANDOM_EFFECTS.duplicate(true)
	effect.quality = StatusEffect.EffectQuality.POSITIVE
	effect.target = cog
	effect.boost = 0.1
	effect.stat = "damage"
	effect.rounds = -1
	await Util.s_process_frame
	BattleService.ongoing_battle.add_status_effect(effect)

func get_mod_name() -> String:
	return "Cog Chaining"

func get_mod_icon() -> Texture2D:
	return load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pause/cogchaining.png")

func get_description() -> String:
	return "Cogs gain +10% damage per round"

func get_mod_quality() -> ModType:
	return ModType.NEGATIVE
