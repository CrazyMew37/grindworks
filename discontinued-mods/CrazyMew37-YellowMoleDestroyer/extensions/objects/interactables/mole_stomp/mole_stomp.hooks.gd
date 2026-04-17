extends Object

func mole_stomped(chain: ModLoaderHookChain) -> void:
	chain.reference_object.moles_stomped += 1
	if chain.reference_object.game_mode == chain.reference_object.GameMode.NORMAL:
		chain.reference_object.update_ui()
		if chain.reference_object.moles_stomped == chain.reference_object.quota:
			chain.reference_object.win_game()
	elif chain.reference_object.game_mode == chain.reference_object.GameMode.MANAGED:
		chain.reference_object.s_managed_red_hit.emit()
