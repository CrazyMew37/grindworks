@tool
extends StatEffectRegeneration
class_name StatEffectAftershockBomb

func renew() -> void:
	# Don't do movie for dead actors
	if not is_instance_valid(target) or target.stats.hp <= 0:
		return
	AudioManager.play_sound(load('res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/Explosion2.ogg'))
	BattleService.battle_node.focus_character(target)
	var kaboom := Sprite3D.new()
	kaboom.render_priority = 1
	kaboom.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	kaboom.texture = load('res://models/props/gags/tnt/kaboom.png')
	target.add_child(kaboom)
	kaboom.global_position = target.global_position
	kaboom.scale *= 0.25
	manager.affect_target(target, amount)
	target.set_animation('slip-backward')
	var kaboom_tween := kaboom.create_tween()
	kaboom_tween.tween_property(kaboom,'pixel_size',.05,1.0)
	await kaboom_tween.finished
	kaboom_tween.kill()
	kaboom.queue_free()
	if target is Player:
		target.last_damage_source = "a TNT explosion"
		await manager.sleep(2.0)
	else:
		await manager.sleep(4.0)
	await manager.check_pulses([target])

func get_description() -> String:
	if not description == "":
		return description
	return "Deals %d damage every round" % amount
