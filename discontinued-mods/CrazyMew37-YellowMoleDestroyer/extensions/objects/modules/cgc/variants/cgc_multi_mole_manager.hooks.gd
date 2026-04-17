extends Object

# these moles give me headaches, I swear. -cm37
func mole_hit(chain: ModLoaderHookChain) -> void:
	chain.reference_object.quota -= 1
	if chain.reference_object.quota == 0:
		chain.reference_object.win_game()
