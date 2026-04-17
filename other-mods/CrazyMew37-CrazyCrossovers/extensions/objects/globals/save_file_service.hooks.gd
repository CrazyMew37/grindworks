extends Object

func _save_run(chain: ModLoaderHookChain) -> void:
	chain.execute_next()
	print("saving run via hook")
	var owner_node = chain.reference_object as Node

	var gf = owner_node.get_tree().get_root().get_node_or_null("/root/ModLoader/CrazyMew37-CrazyCrossovers/CCglobal")
	if gf:
		gf.save_to()
		print("CCglobal data saved.")
	else:
		print("CCglobal not found at /root/ModLoader/CrazyMew37-CrazyCrossovers/CCglobal")
		
func load_run(chain: ModLoaderHookChain) -> String:
	print("attempting to load run via hook")

	var owner_node = chain.reference_object as Node
	var gf = owner_node.get_tree().get_root().get_node_or_null("/root/ModLoader/CrazyMew37-CrazyCrossovers/CCglobal")

	if gf:
		gf.load_save()
		print("CCglobal data loaded.")
	else:
		print("CCglobal not found at /root/ModLoader/CrazyMew37-CrazyCrossovers/CCglobal")

	# Get the return value from the next hook or the vanilla function
	var result := chain.execute_next() as String
	return result

func delete_run_file(chain: ModLoaderHookChain) -> void:
	chain.execute_next()
	print("deleting run via hook")
	var owner_node = chain.reference_object as Node

	var gf = owner_node.get_tree().get_root().get_node_or_null("/root/ModLoader/CrazyMew37-CrazyCrossovers/CCglobal")
	if gf:
		gf.delete_save()
		print("CCglobal data deleted.")
	else:
		print("CCglobal not found at /root/ModLoader/CrazyMew37-CrazyCrossovers/CCglobal")
