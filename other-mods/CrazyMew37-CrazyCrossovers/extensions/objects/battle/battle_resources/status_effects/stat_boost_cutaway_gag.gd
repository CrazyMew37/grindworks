@tool
extends StatusEffect
class_name StatBoostCutawayGag

var ICONS := {
	'Drop': load("res://ui_assets/battle/gags/inventory_safe_box.png"),
	'Trap': load("res://ui_assets/battle/gags/inventory_trapdoor.png"),
	'Lure': load("res://ui_assets/battle/gags/inventory_10dollarbill2.png"),
	'Throw': load("res://ui_assets/battle/gags/inventory_creampie.png"),
	'Sound': load("res://ui_assets/battle/gags/inventory_elephant.png"),
	'Squirt': load("res://ui_assets/battle/gags/inventory_firehose.png"),
}

@export var stat: String = 'Drop'
@export var boost: float = 0.25

func apply():
	if stat in Util.get_player().stats.gag_effectiveness:
		BattleService.ongoing_battle.battle_stats[Util.get_player()].gag_effectiveness[stat] += boost
	
func expire():
	if stat in Util.get_player().stats.gag_effectiveness:
		BattleService.ongoing_battle.battle_stats[Util.get_player()].gag_effectiveness[stat] -= boost

func get_description() -> String:
	return "Affects the damage/effects of {0} by {1}{2}%".format([stat, "+" if boost > 0.0 else "-", roundi(abs(boost) * 100)])

func get_icon() -> Texture2D:
	if boost >= 0.0:
		icon_color = Color(0.66,1,0.66,1.0)
	else:
		icon_color = Color(1,0.66,0.66,1.0)
	if ICONS[stat]:
		return ICONS[stat]
	else:
		return load("res://ui_assets/battle/statuses/leverage.png")

func get_status_name() -> String:
	return "{0} Effectiveness {1}".format([stat, "Up" if boost > 0.0 else "Down"])

func get_quality() -> EffectQuality:
	if boost >= 0.0:
		return EffectQuality.POSITIVE
	return EffectQuality.NEGATIVE
