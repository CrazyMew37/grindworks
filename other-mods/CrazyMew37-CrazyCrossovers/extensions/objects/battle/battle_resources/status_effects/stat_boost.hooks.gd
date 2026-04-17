extends Object

var NEW_ICONS := {
	'damage': load("res://ui_assets/battle/statuses/damage.png"),
	'defense': load("res://ui_assets/battle/statuses/defense.png"),
	'evasiveness': load("res://ui_assets/battle/statuses/evasiveness.png"),
	'luck': load("res://ui_assets/battle/statuses/luck_crit.png"),
	'accuracy': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/battle/statuses/accuracy.png"),
}

func get_icon(chain: ModLoaderHookChain) -> Texture2D:
	return NEW_ICONS[chain.reference_object.stat]
