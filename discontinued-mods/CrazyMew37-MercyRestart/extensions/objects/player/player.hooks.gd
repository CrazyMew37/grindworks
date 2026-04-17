extends Object

func lose(chain: ModLoaderHookChain):
	if chain.reference_object.state == chain.reference_object.PlayerState.SAD:
		# Thog don't care if we're already in the sad state
		return
	
	chain.reference_object.s_dying.emit()
	chain.reference_object.state = chain.reference_object.PlayerState.SAD
	Util.stuck_lock = false
	chain.reference_object.set_animation('lose')
	await Task.delay(2.0)
	AudioManager.play_sound(load('res://audio/sfx/toon/ENC_Lose.ogg'))
	await Task.delay(2.0)
	var shrink_tween = chain.reference_object.create_tween()
	shrink_tween.tween_property(chain.reference_object.toon, 'scale', Vector3(.01, .01, .01), 2.0)
	await shrink_tween.finished
	shrink_tween.kill()
	SaveFileService.progress_file.deaths += 1
	chain.reference_object.s_died.emit()
