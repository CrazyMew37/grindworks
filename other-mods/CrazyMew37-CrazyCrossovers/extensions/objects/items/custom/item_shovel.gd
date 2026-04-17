extends ItemScriptActive

const dig = "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/Shovel.ogg"

func use() -> void:
	AudioManager.play_sound(load(dig))
	var player := Util.get_player()
	var zone
	if is_instance_valid(Util.floor_manager):
		zone = Util.floor_manager.get_current_room()
	else:
		zone = SceneLoader
	var _item: Item = load("res://objects/items/resources/passive/pink_slip.tres")
	_item.apply_item(player)
	_item.play_collection_sound()
	var ui := ItemService.display_item(_item)
	ui.node_viewer.node.setup(_item)
