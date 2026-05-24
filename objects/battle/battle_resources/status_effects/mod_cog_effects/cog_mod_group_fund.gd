@tool
extends StatusEffect

const STAT_BOOST_RATE := 0.1
const STAT_BOOST := "res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres"

var effect: StatBoost
var effect2: StatBoost


func get_status_name() -> String:
	return "Group Fund"

func get_descriptioin() -> String:
	return "Gains +10% damage and defense for every cog in the battle."

func apply() -> void:
	effect = load(STAT_BOOST).duplicate(true)
	effect.rounds = -1
	effect.stat = 'damage'
	effect.target = target
	effect.quality = EffectQuality.POSITIVE
	manager.s_participant_joined.connect(on_participants_changed)
	manager.s_participant_died.connect(on_participants_changed)
	refresh_effect(effect)
	manager.add_status_effect(effect)
	effect2 = load(STAT_BOOST).duplicate(true)
	effect2.stat = 'defense'
	effect2.rounds = -1
	effect2.target = target
	effect2.quality = EffectQuality.POSITIVE
	refresh_effect(effect2)
	manager.add_status_effect(effect2)

func on_participants_changed(_p) -> void:
	if effect:
		refresh_effect(effect)
	if effect2:
		refresh_effect(effect2)

func refresh_effect(effect: StatBoost) -> void:
	effect.boost = (STAT_BOOST_RATE * manager.cogs.size())

func cleanup() -> void:
	manager.expire_status_effect(effect)
	manager.expire_status_effect(effect2)
