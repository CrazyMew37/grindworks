extends Object

const BURN_COLOR := Color(1.0, 0.35, 0.0, 1.0)

func action(chain: ModLoaderHookChain):
	chain.reference_object.user = Util.get_player()
	var cog: Cog = chain.reference_object.targets[0]
	chain.reference_object.user.face_position(cog.global_position)
	var throwable = chain.reference_object.model.instantiate()
	chain.reference_object.user.toon.right_hand_bone.add_child(throwable)
	throwable.scale *= chain.reference_object.scale
	throwable.rotation_degrees.y += 180.0
	chain.reference_object.user.set_animation('pie-throw')
	chain.reference_object.manager.s_focus_char.emit(chain.reference_object.user)
	if chain.reference_object.present_sfx:
		AudioManager.play_sound(chain.reference_object.present_sfx)

	if chain.reference_object.action_name == "Birthday Cake":
		throwable.get_node("AnimationPlayer").play("candles")

	await chain.reference_object.manager.sleep(2.545)
	if not chain.reference_object.throw_sfx:
		AudioManager.play_sound(chain.reference_object.FALLBACK_THROW_SFX)
	else:
		AudioManager.play_sound(chain.reference_object.throw_sfx)
	await chain.reference_object.manager.sleep(0.1)
	throwable.top_level = true
	var throw_tween = chain.reference_object.manager.create_tween()
	throw_tween.tween_property(throwable, 'global_position', cog.head_node.global_position, 0.25)
	
	# Roll for accuracy
	var hit = randf_range(0.0, 1.0)
	
	if hit <= Util.get_player().stats.accuracy or cog.lured:
		await throw_tween.finished
		throw_tween.kill()
		chain.reference_object.user.face_position(chain.reference_object.manager.battle_node.global_position)
		chain.reference_object.manager.s_focus_char.emit(cog)
		throwable.queue_free()
		
		var immune = chain.reference_object.get_immunity(cog)
		
		if not immune:
			var throw_damage: int = chain.reference_object.manager.affect_target(cog, chain.reference_object.damage)
			if chain.reference_object.status_effect:
				chain.reference_object.apply_status_effect()
			if chain.reference_object.user.throw_heals:
				chain.reference_object.user.quick_heal(roundi(throw_damage * chain.reference_object.user.stats.get_stat("throw_heal_boost")))
			chain.reference_object.s_hit.emit()
		else:
			chain.reference_object.manager.battle_text(cog, "IMMUNE")
		
		var splat = load("res://objects/battle/effects/splat/splat.tscn").instantiate()
		if Util.get_player().stats.has_item('Fire Flower'):
			chain.reference_object.splat_color = BURN_COLOR
			splat.modulate = chain.reference_object.splat_color
		else:
			splat.modulate = chain.reference_object.splat_color
		cog.head_node.add_child(splat)
		if chain.reference_object.splat_sfx:
			AudioManager.play_sound(chain.reference_object.splat_sfx)
		
		if not immune:
			if not cog.lured:
				cog.set_animation('pie-small')
				chain.reference_object.do_dizzy_stars(cog)
			else:
				chain.reference_object.manager.knockback_cog(cog)
				chain.reference_object.do_dizzy_stars(cog)
			
		await chain.reference_object.manager.barrier(cog.animator.animation_finished, 4.0)
		await chain.reference_object.manager.check_pulses(chain.reference_object.targets)
	else:
		chain.reference_object.manager.s_focus_char.emit(cog)
		cog.set_animation('sidestep-left')
		if chain.reference_object.miss_sfx:
			AudioManager.play_sound(chain.reference_object.miss_sfx)
		await throw_tween.finished
		throw_tween.kill()
		throwable.queue_free()
		chain.reference_object.manager.battle_text(cog, "MISSED")
		await cog.animator.animation_finished

func get_stats(chain: ModLoaderHookChain) -> String:
	var string = "Damage: " + chain.reference_object.get_true_damage() + "\n"\
	+ "Affects: "
	match chain.reference_object.target_type:
		chain.reference_object.ActionTarget.SELF:
			string += "Self"
		chain.reference_object.ActionTarget.ENEMIES:
			string += "All Cogs"
		chain.reference_object.ActionTarget.ENEMY:
			string += "One Cog"
		chain.reference_object.ActionTarget.ENEMY_SPLASH:
			string += "Three Cogs"

	if Util.get_player().throw_heals:
		var player_stats: PlayerStats
		if is_instance_valid(BattleService.ongoing_battle):
			player_stats = BattleService.ongoing_battle.battle_stats[Util.get_player()]
		else:
			player_stats = Util.get_player().stats
		string += "\nSelf-Heal: %s%%" % roundi(player_stats.get_stat('throw_heal_boost') * 100)

	if Util.get_player().stats.has_item('Fire Flower'):
		string += "\nApplies: Scorched"

	return string
