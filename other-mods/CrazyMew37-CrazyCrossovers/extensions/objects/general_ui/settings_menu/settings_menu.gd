extends "res://objects/general_ui/settings_menu/settings_menu.gd"

# Kudos to Squiddy and their Hatstack mod for making these settings possible. This is complex stuff. -cm37
var EndlessNerfsButton : GeneralButton

var Pla : Player

var endlessnerfsId : int

const EndlessNerfsSetting : Dictionary = {
	0 : "On",
	1 : "Off",
}

func _ready() -> void:
	super()
	var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-CrazyCrossovers", "crossoversettings").data
	endlessnerfsId = SettingsConfig["endlessnerfs"]

	var DupeMenuResource = load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/dupe_settings.tscn")
	var DupeMenu = DupeMenuResource.instantiate()
	var SettingContainer = get_node("Panel/SettingScroller/MarginContainer/SettingContainer")
	add_child(DupeMenu)
	DupeMenu.reparent(SettingContainer)
	
	EndlessNerfsButton = DupeMenu.get_node("%EndlessNerfsButton")
	
	EndlessNerfsButton.text = EndlessNerfsSetting[endlessnerfsId]

	EndlessNerfsButton.connect("pressed", endlessnerfs)

func endlessnerfs() -> void:
	endlessnerfsId += 1
	if endlessnerfsId >= len(EndlessNerfsSetting):
		endlessnerfsId = 0
	EndlessNerfsButton.text = EndlessNerfsSetting[endlessnerfsId]

# It was way, WAY too hard to make the speed cap update live. Thank god I found a way. -cm37
func close(save := false) -> void:
	super(save)
	var endlessConfig = ModLoaderConfig.get_config("CrazyMew37-CrazyCrossovers", "crossoversettings")
	endlessConfig.data = {
		"endlessnerfs": endlessnerfsId,
	}
	ModLoaderConfig.update_config(endlessConfig)
	ModLoaderConfig.refresh_current_configs()
	var PauseChange = get_node("/root/PauseMenu")
	if PauseChange:
		PauseChange.apply_stat_labels()
		PauseChange.apply_stat_changes()
