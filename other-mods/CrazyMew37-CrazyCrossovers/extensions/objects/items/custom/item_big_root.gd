extends ItemScript

var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-CrazyCrossovers", "crossoversettings")
var EndlessNerfsSetting = SettingsConfig.data["endlessnerfs"]
var old_bean_amount : int

func on_collect(_item: Item, _object: Node3D) -> void:
	setup()

func setup() -> void:
	var player := Util.get_player()
	if EndlessNerfsSetting == 0:
		player.stats.throw_heal_boost = min(player.stats.throw_heal_boost + 0.05, 0.25)
	else:
		player.stats.throw_heal_boost += 0.05

func on_item_removed() -> void:
	var player := Util.get_player()
	player.stats.throw_heal_boost -= 0.05
