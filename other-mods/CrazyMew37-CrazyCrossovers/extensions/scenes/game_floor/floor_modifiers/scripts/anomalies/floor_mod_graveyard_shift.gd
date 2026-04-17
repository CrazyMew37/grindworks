extends FloorModifier

const STAT_BOOST := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")

func modify_floor() -> void:
	BattleService.s_battle_started.connect(on_battle_start)
	BattleService.s_round_ended.connect(on_round_ended)

func on_battle_start(_battle: BattleManager) -> void:
	var stat_increase := 0.15
	if Util.floor_number > 5:
		stat_increase = 0.15 * (1 + (floor((Util.floor_number - 1) / 5) * 0.5))
	var player := Util.get_player()
	var effect: StatusEffect = STAT_BOOST.duplicate(true)
	effect.quality = StatusEffect.EffectQuality.NEGATIVE
	effect.target = player
	effect.rounds = 0
	effect.boost = -stat_increase
	effect.stat = "damage"
	BattleService.ongoing_battle.add_status_effect(effect)
	var effect2: StatusEffect = STAT_BOOST.duplicate(true)
	effect2.quality = StatusEffect.EffectQuality.POSITIVE
	effect2.target = player
	effect2.rounds = 0
	effect2.boost = stat_increase
	effect2.stat = "defense"
	BattleService.ongoing_battle.add_status_effect(effect2)
	
	await Util.s_process_frame
	
	BattleService.s_refresh_statuses.emit()

func on_round_ended(_battle: BattleManager) -> void:
	apply_effect()
	
	await Util.s_process_frame
	
	BattleService.s_refresh_statuses.emit()

func apply_effect() -> void:
	var stat_increase := 0.15
	var stat_adjustment := 0.06
	if Util.floor_number > 5:
		stat_increase = 0.15 * (1 + (floor((Util.floor_number - 1) / 5) * 0.5))
		stat_adjustment = 0.06 * (1 + (floor((Util.floor_number - 1) / 5) * 0.5))
	var player := Util.get_player()
	if BattleService.ongoing_battle.current_round < 5:
			var effect: StatusEffect = STAT_BOOST.duplicate(true)
			effect.target = player
			effect.rounds = 0
			effect.boost = (-stat_increase + (stat_adjustment * BattleService.ongoing_battle.current_round))
			if effect.boost > 0.0:
				effect.quality = StatusEffect.EffectQuality.POSITIVE
			else:
				effect.quality = StatusEffect.EffectQuality.NEGATIVE
			effect.stat = "damage"
			BattleService.ongoing_battle.add_status_effect(effect)
			var effect2: StatusEffect = STAT_BOOST.duplicate(true)
			effect2.target = player
			effect2.rounds = 0
			effect2.boost = (stat_increase - (stat_adjustment * BattleService.ongoing_battle.current_round))
			if effect2.boost > 0.0:
				effect2.quality = StatusEffect.EffectQuality.POSITIVE
			else:
				effect2.quality = StatusEffect.EffectQuality.NEGATIVE
			effect2.stat = "defense"
			BattleService.ongoing_battle.add_status_effect(effect2)
	elif BattleService.ongoing_battle.current_round == 5:
			var effect: StatusEffect = STAT_BOOST.duplicate(true)
			effect.quality = StatusEffect.EffectQuality.POSITIVE
			effect.target = player
			effect.rounds = -1
			effect.boost = stat_increase
			effect.stat = "damage"
			BattleService.ongoing_battle.add_status_effect(effect)
			var effect2: StatusEffect = STAT_BOOST.duplicate(true)
			effect2.quality = StatusEffect.EffectQuality.NEGATIVE
			effect2.target = player
			effect2.rounds = -1
			effect2.boost = -stat_increase
			effect2.stat = "defense"
			BattleService.ongoing_battle.add_status_effect(effect2)

func get_mod_name() -> String:
	return "Graveyard Shift"

func get_mod_icon() -> Texture2D:
	return load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pause/graveyardshift.png")

func get_description() -> String:
	return "Begin with -15% Damage and +15% Defense during a battle, which progressively shifts to +15% Damage and -15% Defense over a few rounds (Effects are multiplied by +0.5x every 5 floors with Endless)"

func get_mod_quality() -> ModType:
	return ModType.NEUTRAL
