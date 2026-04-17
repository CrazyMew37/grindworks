extends Object

func ban_random_track(chain: ModLoaderHookChain, _actions: Array[BattleAction] = []) -> void:
	if chain.reference_object.trimmed_list.size() > 0:
		chain.reference_object.trimmed_list.shuffle()
		var new_track: Track = chain.reference_object.trimmed_list.pop_back()
		for gag in new_track.gags:
			chain.reference_object.banned_effect.gags.append(gag)
		chain.reference_object.banned_tracks.append(new_track)
	else:
		var new_track: Track = chain.reference_object.banned_tracks.pick_random()
		for gag in new_track.gags:
			chain.reference_object.banned_effect.gags.append(gag)
		chain.reference_object.banned_tracks.append(new_track)
