extends CogAttack

const FIRE = preload("res://objects/battle/effects/fire/fire.tscn")
const FIRE_BURST := preload("res://objects/battle/effects/fire/fireburst.tscn")
const SFX_FLAMES := preload("res://audio/sfx/battle/cogs/attacks/SA_hot_air.ogg")
var fire: GPUParticles3D
var target = Util.get_player()

func action() -> void:
	# Movie Start
	var movie := manager.create_tween()
	fire = FIRE.instantiate()
	var burn_damage = ((Util.floor_number + 1) * BattleService.ongoing_battle.cogs.size())
	
	# Focus Cog
	movie.tween_callback(battle_node.focus_character.bind(user))
	movie.tween_callback(user.face_position.bind(target.global_position))
	movie.tween_callback(user.set_animation.bind('magic1'))
	movie.tween_callback(AudioManager.play_sound.bind(SFX_FLAMES))
	movie.tween_interval(2.5)
	
	# Focus Toon
	movie.tween_callback(do_fire_burst)
	movie.tween_callback(battle_node.focus_character.bind(target))
	movie.tween_callback(target.set_animation.bind('slip-forward'))
	movie.tween_callback(manager.affect_target.bind(target, burn_damage))
	movie.tween_interval(4.0)

	await movie.finished
	movie.kill()
	await manager.check_pulses([target])

func do_fire_burst() -> void:
	var fire_burst := FIRE_BURST.instantiate()
	manager.battle_node.add_child(fire_burst)
	fire_burst.global_position = target.toon.backpack_bone.global_position
	for child in fire_burst.get_children():
		if child is GPUParticles3D:
			child.emitting = true
	await Task.delay(1.5)
	fire_burst.queue_free()
