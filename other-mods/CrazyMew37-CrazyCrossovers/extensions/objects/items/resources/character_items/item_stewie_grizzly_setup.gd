extends ItemCharSetup

func first_time_setup(_player: Player) -> void:
	ItemService.seen_item(preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/rupert.tres"))
