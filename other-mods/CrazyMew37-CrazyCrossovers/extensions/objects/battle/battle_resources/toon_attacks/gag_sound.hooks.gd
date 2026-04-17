extends Object

var cc: Node = null

func action(chain: ModLoaderHookChain):
	getCC()
	# Play the movie's sfx
	chain.reference_object.sfx_track()
	
	# Begin
	if is_instance_valid(chain.reference_object.main_target):
		chain.reference_object.user.face_position(chain.reference_object.main_target.global_position)
	else:
		chain.reference_object.user.face_position(chain.reference_object.manager.battle_node.global_position)
	chain.reference_object.user.set_animation('shout')
	chain.reference_object.manager.s_focus_char.emit(chain.reference_object.user)
	
	# Add the megaphone
	var megaphone: Node3D = load("res://models/props/gags/megaphone/megaphone.tscn").instantiate()
	chain.reference_object.user.toon.right_hand_bone.add_child(megaphone)
	megaphone.rotation_degrees += Vector3(0.0, 180.0, 0.0)
	
	# Add gag to megaphone
	var gag = chain.reference_object.model.instantiate()
	megaphone.add_child(gag)
	# Transform the model
	gag.position = chain.reference_object.position
	gag.rotation_degrees = chain.reference_object.rotation
	gag.scale = chain.reference_object.scale
	
	# Wait until sound plays
	await chain.reference_object.manager.sleep(chain.reference_object.anim_delay)
	gag.get_node('AnimationPlayer').play('sound')
	
	# Wait until sound plays
	await chain.reference_object.manager.sleep(2.4 - chain.reference_object.anim_delay)
	chain.reference_object.manager.battle_node.focus_cogs()
	
	# This was surprisingly annoying to deal with. Hope it doesn't screw anything up when it comes to RNG. -cm37
	var hit = randf_range(0.0, 1.0)
	
	if hit <= Util.get_player().stats.accuracy:
		# If we're doing knockback and any of our targets are lured,
		# give the funny special text
		if chain.reference_object.do_knockback and chain.reference_object.targets.filter(func(x: Cog): return x.lured and not chain.reference_object.get_immunity(x)).size() > 0:
			chain.reference_object.store_boost_text("Rude Awakening!", Color(0.328, 0.4, 0.96))

		var animator_target: Cog = null
		for target: Cog in chain.reference_object.targets:
			if not is_instance_valid(target):
				continue
			animator_target = target
			var real_damage = chain.reference_object.damage
			if (not target == chain.reference_object.main_target and not chain.reference_object.user.inverted_sound_damage) or (chain.reference_object.user.inverted_sound_damage and target == chain.reference_object.main_target):
				real_damage *= (0.5 + cc.sound_splash_boost)
			if chain.reference_object.get_immunity(target):
				chain.reference_object.manager.battle_text(target, 'IMMUNE')
			else:
				chain.reference_object.manager.affect_target(target, real_damage)
			if not target.lured or not chain.reference_object.do_knockback:
				target.set_animation('squirt-small')
				chain.reference_object.do_dizzy_stars(target)
			elif not chain.reference_object.get_immunity(target):
				chain.reference_object.manager.knockback_cog(target)
				chain.reference_object.do_dizzy_stars(target)
		
		if animator_target:
			await chain.reference_object.manager.barrier(animator_target.animator.animation_finished, 5.0)
		
		# Check if any cogs are lured, and unlure them
		var lured_targets: Array[Cog] = []
		for target in chain.reference_object.targets:
			if target.lured:
				lured_targets.append(target)
		if not lured_targets.is_empty():
			var unlure_tween: Tween = chain.reference_object.manager.create_tween()
			unlure_tween.set_parallel(true)
			for target in lured_targets:
				target.set_animation('walk')
				unlure_tween.tween_property(target.get_node('Body'),'position:z',0,1.0)
				chain.reference_object.manager.force_unlure(target)
			await unlure_tween.finished
			for target in lured_targets:
				target.set_animation('neutral')
		await chain.reference_object.manager.check_pulses(chain.reference_object.targets)
	else:
		for target in chain.reference_object.targets:
			chain.reference_object.manager.battle_text(target,"MISSED")
		await chain.reference_object.manager.sleep(1.0)
	
	if chain.reference_object.user.get_animation() == 'shout':
		await chain.reference_object.manager.barrier(chain.reference_object.user.animator.animation_finished, 4.0)
	
	megaphone.queue_free()
	
func get_main_damage_str(chain: ModLoaderHookChain) -> String:
	getCC()
	if Util.get_player().inverted_sound_damage:
		return chain.reference_object.get_true_damage(0.5 + cc.sound_splash_boost)
	return chain.reference_object.get_true_damage()

func get_splash_damage_str(chain: ModLoaderHookChain) -> String:
	getCC()
	if Util.get_player().inverted_sound_damage:
		return chain.reference_object.get_true_damage()
	return chain.reference_object.get_true_damage(0.5 + cc.sound_splash_boost)
	
func getCC() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	var root := tree.get_root()
	cc = root.get_node_or_null("/root/ModLoader/CrazyMew37-CrazyCrossovers/CCglobal")
