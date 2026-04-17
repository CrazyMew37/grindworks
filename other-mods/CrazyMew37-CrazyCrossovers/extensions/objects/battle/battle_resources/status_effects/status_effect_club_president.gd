@tool
extends StatusEffect

var DEFENSE_RATE := 1.2
var DAMAGE_RATE := 0.2
var DEFENSE_BOOST := 3.5
var DAMAGE_BOOST := -0.1
const STAT_BOOSTS := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")

var toon_effect: StatBoost
var toon_effect_2: StatBoost
var applied = false

func apply() -> void:
	if Util.on_easy_floor() and applied == false:
		DEFENSE_BOOST = 2.0
	if applied == false:
		manager.s_participant_joined.connect(on_participants_changed)
		manager.s_participant_died.connect(on_participants_changed)
		manager.s_round_ended.connect(refresh_effect)
	# Defense Boost
	toon_effect = STAT_BOOSTS.duplicate(true)
	toon_effect.target = target
	toon_effect.rounds = -1
	toon_effect.stat = "defense"
	if sign(DEFENSE_BOOST) == 1:
		toon_effect.quality = StatusEffect.EffectQuality.POSITIVE
	else:
		toon_effect.quality = StatusEffect.EffectQuality.NEGATIVE
	toon_effect.boost = DEFENSE_BOOST
	manager.add_status_effect(toon_effect)
	# Attack Boost
	toon_effect_2 = STAT_BOOSTS.duplicate(true)
	toon_effect_2.target = target
	toon_effect_2.rounds = -1
	toon_effect_2.stat = "damage"
	if sign(DAMAGE_BOOST) == 1:
		toon_effect_2.quality = StatusEffect.EffectQuality.POSITIVE
	else:
		toon_effect_2.quality = StatusEffect.EffectQuality.NEGATIVE
	toon_effect_2.boost = DAMAGE_BOOST
	manager.add_status_effect(toon_effect_2)
	applied = true

func on_participants_changed(_p) -> void:
	if toon_effect:
		refresh_effect()

func refresh_effect() -> void:
	if manager.cogs.size() > 0:
		manager.expire_status_effect(toon_effect)
		manager.expire_status_effect(toon_effect_2)
		if Util.on_easy_floor():
			DEFENSE_RATE = 0.7
		DEFENSE_BOOST = -0.1 + (DEFENSE_RATE * (manager.cogs.size() - 1))
		if Util.on_easy_floor():
			DAMAGE_RATE = 0.15
		DAMAGE_BOOST = -0.1 + (DAMAGE_RATE * (4 - manager.cogs.size()))
		apply()

func cleanup() -> void:
	manager.expire_status_effect(toon_effect)
	manager.expire_status_effect(toon_effect_2)
