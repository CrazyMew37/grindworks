extends ItemScript

func on_collect(item : Item, object : Node3D) -> void:
	var toon : RoamingToon = object.doodle
	item.arbitrary_data['dna'] = toon.toon.toon_dna

func on_load(item : Item) -> void:
	# Create the doodle object from scratch
	var toon : Actor = $RoamingToon
	SceneLoader.add_persistent_node(toon)
	toon.toon.hide()
	
	# Try to re-apply saved DNA
	if item.arbitrary_data.has('dna'):
		var toon_dna : ToonDNA = item.arbitrary_data['dna']
		toon.toon.toon_dna = toon_dna
		toon.toon.construct_toon(toon_dna)
	else:
		var toon_dna := ToonDNA.new()
		toon_dna.randomize_dna()
		toon.toon.toon_dna = toon_dna
		toon.toon.construct_toon(toon_dna)
	
	# Give Doodle the item so that it can modify it
	toon.item = item
	
	Util.get_player().partners.append(toon)
	
	# Wait for a moment to set doodle state to avoid error
	await Task.delay(1.0)
	toon.state = RoamingToon.DoodleState.AWAIT
	
	
