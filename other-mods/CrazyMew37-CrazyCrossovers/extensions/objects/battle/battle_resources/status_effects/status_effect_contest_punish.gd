@tool
extends StatEffectRegeneration

var DEFENSE_DOWN_EFFECT = preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")

func renew() -> void:
	# Don't do movie for dead actors
	if not is_instance_valid(target) or target.stats.hp <= 0:
		return
	AudioManager.play_sound.bind(target.toon.yelp)
	Util.get_player().boost_queue.queue_text("You failed to do the contest! You're up for elimination!", Color(0.85, 0.283, 0.0, 1.0))
	BattleService.battle_node.focus_character(target)
	Util.do_3d_text(target, "Defense Down!")
	target.set_animation('cringe')
	create_debuff()
	await manager.sleep(2.25)

func create_debuff() -> void:
	var effect := DEFENSE_DOWN_EFFECT.duplicate(true)
	effect.quality = StatusEffect.EffectQuality.NEGATIVE
	effect.rounds = -1
	effect.boost = -0.25
	effect.stat = 'defense'
	effect.target = target
	manager.add_status_effect(effect)

func get_description() -> String:
	if not description == "":
		return description
	return "Deals %d damage every round" % amount
