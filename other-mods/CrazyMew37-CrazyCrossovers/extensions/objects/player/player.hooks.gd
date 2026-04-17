extends Object

func reset_stats(chain: ModLoaderHookChain) -> void:
	chain.execute_next()
	var owner_node = (Engine.get_main_loop() as SceneTree).get_root()
	if owner_node == null:
		print("Hook error: reference_object is not a Node.")
		return
	
	# Try to directly get the GFglobal node
	var cc = owner_node.get_node_or_null("ModLoader/CrazyMew37-CrazyCrossovers/CCglobal")
	
	if cc:
		cc.reset_stats()
		print("CCglobal stats reset.")
	else:
		print("CCglobal not found.")
