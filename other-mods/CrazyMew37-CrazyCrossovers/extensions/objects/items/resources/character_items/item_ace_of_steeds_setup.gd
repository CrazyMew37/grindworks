extends ItemCharSetup

func first_time_setup(_player: Player) -> void:
	ItemService.seen_item(preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/ace_of_clubs.tres"))
	ItemService.seen_item(preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/ace_of_spades.tres"))
	ItemService.seen_item(preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/ace_of_diamonds.tres"))
	ItemService.seen_item(preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/ace_of_hearts.tres"))
