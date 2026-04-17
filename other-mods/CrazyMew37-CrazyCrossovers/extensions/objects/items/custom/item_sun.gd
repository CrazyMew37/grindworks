extends ItemScript

func on_collect(_item: Item, _object: Node3D) -> void:
	# Boost all tracks by 1
	for track in Util.get_player().stats.gag_balance.keys():
		Util.get_player().stats.gag_regeneration[track] += 1

func on_item_removed() -> void:
	# bye bye boost -cm37
	for track in Util.get_player().stats.gag_balance.keys():
		Util.get_player().stats.gag_regeneration[track] -= 1
