extends Object

func require_random_track(chain: ModLoaderHookChain) -> void:
	if chain.reference_object.expires_this_round:
		return
	if chain.reference_object.trimmed_list.size() > 0:
		chain.reference_object.trimmed_list.shuffle()
		var new_track: Track = chain.reference_object.trimmed_list.pop_back()
		chain.reference_object.required_tracks.append(new_track)
		var new_effect = chain.reference_object.make_banned_effect(new_track.gags)
		chain.reference_object.manager.add_status_effect(new_effect)
		chain.reference_object.ban_effects.append(new_effect)
	else:
		var new_track: Track = chain.reference_object.required_tracks.pick_random()
		chain.reference_object.required_tracks.append(new_track)
		var new_effect = chain.reference_object.make_banned_effect(new_track.gags)
		chain.reference_object.manager.add_status_effect(new_effect)
		chain.reference_object.ban_effects.append(new_effect)
