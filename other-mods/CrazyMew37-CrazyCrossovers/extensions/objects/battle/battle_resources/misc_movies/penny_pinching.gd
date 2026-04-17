@tool
extends CogAttack

const STAT_BOOSTS: StatBoost = preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")

const SFX_MONEY_NOISE := preload("res://audio/sfx/items/cash_register.ogg")

var stat_up = 0.2

func action() -> void:
	# Get target Cog
	if targets.is_empty():
		return
	
	var target_cog: Cog = targets[0]

	# Focus Cog
	user.set_animation('effort')
	battle_node.focus_character(user)
	
	await manager.sleep(3.0)

	battle_node.focus_character(target_cog)
	target_cog.set_animation('pie-small')
	AudioManager.play_sound(SFX_MONEY_NOISE)
	
	# Apply the status effect
	if Util.on_easy_floor():
		stat_up = 0.1
	
	var defense_down: StatBoost = STAT_BOOSTS.duplicate(true)
	defense_down.target = target_cog
	defense_down.rounds = -1
	defense_down.boost = -0.1
	defense_down.quality = StatusEffect.EffectQuality.NEGATIVE
	manager.add_status_effect(defense_down)
	
	var attack_down: StatBoost = STAT_BOOSTS.duplicate(true)
	attack_down.target = target_cog
	attack_down.stat = "damage"
	attack_down.rounds = -1
	attack_down.boost = -0.1
	attack_down.quality = StatusEffect.EffectQuality.NEGATIVE
	manager.add_status_effect(attack_down)
	
	var acc_down: StatBoost = STAT_BOOSTS.duplicate(true)
	acc_down.target = target_cog
	acc_down.stat = "accuracy"
	acc_down.rounds = -1
	acc_down.boost = -0.1
	acc_down.quality = StatusEffect.EffectQuality.NEGATIVE
	manager.add_status_effect(acc_down)
	
	var defense_up: StatBoost = STAT_BOOSTS.duplicate(true)
	defense_up.target = user
	defense_up.rounds = -1
	defense_up.boost = stat_up
	defense_up.quality = StatusEffect.EffectQuality.POSITIVE
	manager.add_status_effect(defense_up)
	
	var attack_up: StatBoost = STAT_BOOSTS.duplicate(true)
	attack_up.target = user
	attack_up.stat = "damage"
	attack_up.rounds = -1
	attack_up.boost = stat_up
	attack_up.quality = StatusEffect.EffectQuality.POSITIVE
	manager.add_status_effect(attack_up)
	
	var acc_up: StatBoost = STAT_BOOSTS.duplicate(true)
	acc_up.target = user
	acc_up.stat = "accuracy"
	acc_up.rounds = -1
	acc_up.boost = stat_up
	acc_up.quality = StatusEffect.EffectQuality.POSITIVE
	manager.add_status_effect(acc_up)
	
	await manager.sleep(2.75)
