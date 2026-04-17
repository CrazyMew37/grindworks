extends FloorModifier

const RANDOM_EFFECTS := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/status_effects/status_effect_gag_resistance.tres")

func modify_floor() -> void:
	BattleService.s_battle_started.connect(on_battle_start)

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

func apply_effect(cog: Cog) -> void:
	var effect: StatusEffect = RANDOM_EFFECTS.duplicate(true)
	var track_list: Array[Track] = Util.get_player().stats.character.gag_loadout.loadout.duplicate(true)
	track_list.shuffle()
	var gag_choice = track_list.pop_front().track_name
	effect.quality = StatusEffect.EffectQuality.POSITIVE
	effect.target = cog
	effect.boost = 0.5
	effect.gag_type = gag_choice
	var effect2: StatusEffect = RANDOM_EFFECTS.duplicate(true)
	var gag_choice2 = track_list.pop_front().track_name
	effect2.quality = StatusEffect.EffectQuality.NEGATIVE
	effect2.target = cog
	effect2.boost = 1.5
	effect2.gag_type = gag_choice2
	await Util.s_process_frame
	BattleService.ongoing_battle.add_status_effect(effect)
	BattleService.ongoing_battle.add_status_effect(effect2)

func get_mod_name() -> String:
	return "Elemental Enigma"

func get_mod_icon() -> Texture2D:
	return load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pause/elementalenigma.png")

func get_description() -> String:
	return "Cogs gain +50% resistance and -50% weakness to two random gags"

func get_mod_quality() -> ModType:
	return ModType.NEUTRAL
