@tool
extends StatusEffect

var effect = "res://objects/battle/battle_resources/status_effects/resources/status_effect_gag_immunity.tres"

func get_status_name() -> String:
	return "Tolerant"

func get_descriptioin() -> String:
	return "After being hit by a gag, this cog will become immune to gags of the same track for the rest of the round."

func apply() -> void:
	target.stats.hp_changed.connect(on_hp_changed)

func on_hp_changed(_hp) -> void:
	if target:
		if BattleService.ongoing_battle.current_action is GagSquirt:
			apply_effect(load("res://objects/battle/battle_resources/gag_loadouts/gag_tracks/squirt.tres"))
		elif BattleService.ongoing_battle.current_action is GagTrap:
			apply_effect(load("res://objects/battle/battle_resources/gag_loadouts/gag_tracks/trap.tres"))
		elif BattleService.ongoing_battle.current_action is GagLure:
			apply_effect(load("res://objects/battle/battle_resources/gag_loadouts/gag_tracks/lure.tres"))
		elif BattleService.ongoing_battle.current_action is GagSound:
			apply_effect(load("res://objects/battle/battle_resources/gag_loadouts/gag_tracks/sound.tres"))
		elif BattleService.ongoing_battle.current_action is GagThrow:
			apply_effect(load("res://objects/battle/battle_resources/gag_loadouts/gag_tracks/throw.tres"))
		elif BattleService.ongoing_battle.current_action is GagDrop:
			apply_effect(load("res://objects/battle/battle_resources/gag_loadouts/gag_tracks/drop.tres"))

func apply_effect(gag_track: Track) -> void:
	await Task.delay(0.25)
	var new_effect = load(effect).duplicate(true)
	new_effect.track = gag_track
	new_effect.rounds = 0
	new_effect.target = target
	manager.add_status_effect(new_effect)
