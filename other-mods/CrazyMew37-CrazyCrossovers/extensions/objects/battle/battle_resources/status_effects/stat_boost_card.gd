@tool
extends StatusEffect
class_name StatBoostCard

var ICONS := {
	'damage': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pocket_prank_icons/aceofspadesicon.png"),
	'defense': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pocket_prank_icons/aceofdiamondsicon.png"),
	'evasiveness': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pocket_prank_icons/aceofheartsicon.png"),
	'luck': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pocket_prank_icons/aceofclubsicon.png"),
}

var CARD_NAMES := {
	'damage': "Spades",
	'defense': "Diamonds",
	'evasiveness': "Hearts",
	'luck': "Clubs",
}

@export var stat: String = 'defense'
@export var boost: float = 1.0


func apply():
	var battle_stats: BattleStats = manager.battle_stats[target]
	if stat in battle_stats:
		battle_stats.set(stat,battle_stats.get(stat) * boost)

func expire():
	var battle_stats = manager.battle_stats[target]
	if stat in battle_stats:
		battle_stats.set(stat, battle_stats.get(stat) / boost) 

func get_description() -> String:
	return "{0}x {1}".format([snapped(boost, 0.01), stat[0].to_upper() + stat.substr(1)])

func get_icon() -> Texture2D:
	return ICONS[stat]

func get_status_name() -> String:
	return stat[0].to_upper() + stat.substr(1) + (" Multiplier (Ace of ") + CARD_NAMES[stat] + (")")

func get_quality() -> EffectQuality:
	if boost >= 1.0:
		return EffectQuality.POSITIVE
	return EffectQuality.NEGATIVE

func randomize_effect() -> void:
	stat = ICONS.keys().pick_random()
	rounds = randi_range(1, 3)
	boost = randf_range(0.65, 1.35)
	if boost > 0.0:
		quality = StatusEffect.EffectQuality.POSITIVE
	else:
		quality = StatusEffect.EffectQuality.NEGATIVE
