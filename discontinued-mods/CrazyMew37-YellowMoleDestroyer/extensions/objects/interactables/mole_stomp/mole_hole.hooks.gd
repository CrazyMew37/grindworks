extends Object

func try_stomp(chain: ModLoaderHookChain) -> void:
	if chain.reference_object.mole_current == chain.reference_object.Mole.NONE:
		return
	
	if Util.get_player().state == Player.PlayerState.STOPPED:
		return
	
	var mole = chain.reference_object.mole_current
	
	chain.reference_object.timer.stop()
	
	var tween = chain.reference_object.pop_mole(chain.reference_object.Mole.NONE)
	
	match mole:
		chain.reference_object.Mole.COG:
			AudioManager.play_sound(chain.reference_object.SFX_STOMP)
			chain.reference_object.make_hit_tween()
			chain.reference_object.s_stomped.emit()
			chain.reference_object.s_stomped.emit()
		chain.reference_object.Mole.NORMAL:
			if not Util.get_player().get_collision_layer_value(Globals.HAZARD_COLLISION_LAYER):
				return
			AudioManager.play_sound(chain.reference_object.SFX_SURPRISE)
			chain.reference_object.mole_surprised.show()
			chain.reference_object.mole_norm.hide()
			tween.finished.connect(func():
				chain.reference_object.mole_surprised.hide()
				chain.reference_object.mole_norm.show()
			)
			chain.reference_object.make_hit_tween()
			chain.reference_object.s_stomped.emit()
