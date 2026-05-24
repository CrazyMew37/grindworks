@tool
extends StatusEffect

const STAT_BOOST_RATE := 1.0
const STAT_BOOST := "res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres"

var effect: StatBoost
var effect2: StatBoost
var effect3: StatBoost


func get_status_name() -> String:
	return "Monopolist"

func get_descriptioin() -> String:
	return "+100% damage, defense, and accuracy if this cog is the only one in the battle."

func apply() -> void:
	manager.s_participant_joined.connect(on_participants_changed)
	manager.s_participant_died.connect(on_participants_changed)

func on_participants_changed(_p) -> void:
	refresh_effect()

func refresh_effect() -> void:
	if manager.cogs.size() < 2 && target:
		effect = load(STAT_BOOST).duplicate(true)
		effect.rounds = -1
		effect.stat = 'damage'
		effect.target = target
		effect.boost = 1.0
		effect.quality = EffectQuality.POSITIVE
		manager.add_status_effect(effect)
		effect2 = load(STAT_BOOST).duplicate(true)
		effect2.stat = 'defense'
		effect2.rounds = -1
		effect2.target = target
		effect2.boost = 1.0
		effect2.quality = EffectQuality.POSITIVE
		manager.add_status_effect(effect2)
		effect3 = load(STAT_BOOST).duplicate(true)
		effect3.stat = 'accuracy'
		effect3.rounds = -1
		effect3.target = target
		effect3.boost = 1.0
		effect3.quality = EffectQuality.POSITIVE
		manager.add_status_effect(effect3)
	else:
		# if somehow a new cog comes into play via carbob copy or otherwise
		if effect:
			manager.expire_status_effect(effect)
		if effect2:
			manager.expire_status_effect(effect2)
		if effect3:
			manager.expire_status_effect(effect3)

func cleanup() -> void:
	manager.expire_status_effect(effect)
	manager.expire_status_effect(effect2)
	manager.expire_status_effect(effect3)
