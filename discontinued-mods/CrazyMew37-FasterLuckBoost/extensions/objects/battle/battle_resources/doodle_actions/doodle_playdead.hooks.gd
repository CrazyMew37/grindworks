extends Object

var NewSFX = load('res://audio/sfx/doodle/teleport_reappear.ogg')

func action(chain: ModLoaderHookChain):
	# Setup
	var target = chain.reference_object.targets[0] # Player
	
	# Begin (await an additional half second for pacing)
	await chain.reference_object.begin_trick()
	await chain.reference_object.manager.sleep(0.5)
	
	# Show the move's effect
	chain.reference_object.manager.show_action_name("Luck Boost!")
	
	# Do play dead anim
	chain.reference_object.user.set_animation('disappear')
	await chain.reference_object.user.animator.animation_finished
	await chain.reference_object.manager.sleep(1)
	
	chain.reference_object.user.set_animation('appear')
	AudioManager.play_sound(NewSFX)
	await chain.reference_object.user.animator.animation_finished
	
	# Apply the 1 round status effect
	var stat_effect = chain.reference_object.create_stat_boost('luck', 0.33)
	chain.reference_object.manager.add_status_effect(stat_effect)
	
	# Focus player
	chain.reference_object.manager.s_focus_char.emit(target)
	target.toon.speak("Ha Ha Ha!")
	
	# End
	await chain.reference_object.end_trick()
