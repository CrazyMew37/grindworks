@tool
extends CogAttack

const STAT_BOOSTS = preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/status_effects/status_effect_crit_chance_up.tres")

const SFX_MONEY_NOISE := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/s_kill_glitch1.ogg")

var stat_up = 0.3

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
	
	target_cog.stats.hp = 0
	
	var attack_up = STAT_BOOSTS.duplicate(true)
	attack_up.target = user
	attack_up.rounds = -1
	attack_up.boost = stat_up
	attack_up.quality = StatusEffect.EffectQuality.POSITIVE
	manager.add_status_effect(attack_up)
	
	await manager.sleep(2.75)
