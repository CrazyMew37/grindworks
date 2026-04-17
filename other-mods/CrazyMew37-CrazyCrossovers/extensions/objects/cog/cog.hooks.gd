extends Object

# totally didn't take this from Endless hehehe -cm37
func roll_for_level(chain: ModLoaderHookChain) -> void:
	# Get a random cog level first
	if chain.reference_object.level == 0:
		if is_instance_valid(Util.floor_manager):
			chain.reference_object.custom_level_range = Util.floor_manager.level_range
		elif chain.reference_object.dna: 
			chain.reference_object.custom_level_range = Vector2i(chain.reference_object.dna.level_low, chain.reference_object.dna.level_high)
		chain.reference_object.level = RNG.channel(RNG.ChannelCogLevels).randi_range(chain.reference_object.custom_level_range.x, chain.reference_object.custom_level_range.y)
	
	# Allow for Cogs to be higher level than the floor intends
	if sign( chain.reference_object.level_range_offset) == 1:
		if Util.floor_number > 5:
			chain.reference_object.level = chain.reference_object.custom_level_range.y + (chain.reference_object.level_range_offset * ceili(Util.floor_number * 0.2))
		else:
			chain.reference_object.level = chain.reference_object.custom_level_range.y + chain.reference_object.level_range_offset
	elif sign( chain.reference_object.level_range_offset) == -1:
		if Util.floor_number > 5:
			chain.reference_object.level = (chain.reference_object.custom_level_range.y + (chain.reference_object.level_range_offset * ceili(Util.floor_number * 0.2))) + (1 * ceili(Util.floor_number * 0.2))
		else:
			chain.reference_object.level = (chain.reference_object.custom_level_range.y + chain.reference_object.level_range_offset) + 1
