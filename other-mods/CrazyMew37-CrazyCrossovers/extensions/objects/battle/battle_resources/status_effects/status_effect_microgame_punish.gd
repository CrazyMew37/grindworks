@tool
extends StatEffectRegeneration

func renew() -> void:
	# Don't do movie for dead actors
	if not is_instance_valid(target) or target.stats.hp <= 0:
		return
	AudioManager.play_sound(load('res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/microgame_lose.ogg'))
	Util.get_player().boost_queue.queue_text("You failed to pick the right gag!", Color(0.85, 0.283, 0.0, 1.0))
	BattleService.battle_node.focus_character(target)
	manager.affect_target(target, amount)
	target.set_animation('slip-backward')
	if target is Player:
		target.last_damage_source = "failing their Microgames"
		await manager.sleep(2.0)
	else:
		await manager.sleep(4.0)
	await manager.check_pulses([target])

func get_description() -> String:
	if not description == "":
		return description
	return "Deals %d damage every round" % amount
