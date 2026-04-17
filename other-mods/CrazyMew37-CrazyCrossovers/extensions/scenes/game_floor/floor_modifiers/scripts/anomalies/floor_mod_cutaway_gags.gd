extends FloorModifier

# Aw gee Lois, this is worse than the time I became an anomaly in Toontown: the Grindworks -Peter Griffin

const RANDOM_EFFECTS := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/status_effects/status_effect_stat_boost_cutaway_gag.tres")

func modify_floor() -> void:
	BattleService.s_battle_started.connect(on_battle_start)
	BattleService.s_round_ended.connect(on_battle_start)

func on_battle_start(_battle: BattleManager) -> void:
	apply_effect()
	
	await Util.s_process_frame
	
	BattleService.s_refresh_statuses.emit()

func apply_effect() -> void:
	var player := Util.get_player()
	var gag_number := 1
	var track_list: Array[Track] = Util.get_player().stats.character.gag_loadout.loadout.duplicate(true)
	track_list.shuffle()
	await Util.s_process_frame
	for track in track_list:
		if gag_number % 2 == 1:
			var effect: StatusEffect = RANDOM_EFFECTS.duplicate(true)
			var gag_choice = track.track_name
			effect.quality = StatusEffect.EffectQuality.POSITIVE
			effect.target = player
			effect.rounds = 0
			effect.boost = 0.2
			effect.stat = gag_choice
			BattleService.ongoing_battle.add_status_effect(effect)
			gag_number += 1
		else:
			var effect: StatusEffect = RANDOM_EFFECTS.duplicate(true)
			var gag_choice = track.track_name
			effect.quality = StatusEffect.EffectQuality.NEGATIVE
			effect.target = player
			effect.rounds = 0
			effect.boost = -0.2
			effect.stat = gag_choice
			BattleService.ongoing_battle.add_status_effect(effect)
			gag_number += 1

func get_mod_name() -> String:
	return "Cutaway Gags"

func get_mod_icon() -> Texture2D:
	return load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pause/cutawaygags.png")

func get_description() -> String:
	return "Half of your gags gain 20% effectiveness while the other half loses 20% effectiveness every round"

func get_mod_quality() -> ModType:
	return ModType.NEUTRAL
