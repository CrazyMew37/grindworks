extends CogAttack


func action():
	# Setup
	var hit := manager.roll_for_accuracy(self)
	var target : Player = targets[0]
	user.face_position(target.global_position)
	var tween := manager.create_tween()
	manager.s_focus_char.emit(user)
	tween.tween_callback(user.set_animation.bind('magic2'))
	
	await manager.sleep(0.5)
	AudioManager.play_sound(load('res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/fnafjumpscare.ogg'))
	await manager.sleep(0.5)
	manager.s_focus_char.emit(target)
	
	# Base toon anim on whether target was hit
	if hit:
		target.set_animation('duck')
		target.speak('OOOOOO AHHHHHH!!!')
	else:
		target.set_animation('shrug')
		target.speak('That was not very scary.')
	
	# Affect target, or don't
	if hit:
		manager.affect_target(target, damage)
	else:
		manager.battle_text(target,"MISSED")

	tween.kill()
	
	await manager.barrier(target.animator.animation_finished, 5.0)
	
	await manager.check_pulses(targets)
