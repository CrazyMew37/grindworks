@tool
extends StatusEffect
class_name StatBoostPuyo

var ICONS := {
	'damage': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pocket_prank_icons/redpuyo.png"),
	'defense': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pocket_prank_icons/bluepuyo.png"),
	'evasiveness': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pocket_prank_icons/purplepuyo.png"),
	'luck': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pocket_prank_icons/greenpuyo.png"),
	'crit_mult': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pocket_prank_icons/yellowpuyo.png"),
}

@export var stat: String = 'defense'
@export var boost: float = 1.0


func apply():
	var battle_stats: BattleStats = manager.battle_stats[target]
	if stat in battle_stats:
		battle_stats.set(stat,battle_stats.get(stat) + boost)

func expire():
	var battle_stats = manager.battle_stats[target]
	if stat in battle_stats:
		battle_stats.set(stat, battle_stats.get(stat) - boost) 

func get_description() -> String:
	if stat == "crit_mult":
		return "%s%s%% %s" % ["+" if boost > 0.0 else "-", roundi(abs(boost) * 100), "Crit Damage Multiplier"]
	else:
		return "%s%s%% %s" % ["+" if boost > 0.0 else "-", roundi(abs(boost) * 100), stat[0].to_upper() + stat.substr(1)]

func get_icon() -> Texture2D:
	return ICONS[stat]

func get_status_name() -> String:
	if stat == "crit_mult":
		return "Crit Damage Multiplier Chaining"
	else:
		return stat[0].to_upper() + stat.substr(1) + " Chaining"

func combine(effect: StatusEffect) -> bool:
	if not effect is StatBoostPuyo:
		return false
	
	if force_no_combine or effect.force_no_combine:
		return false

	if effect is StatBoostPuyo:
		if effect.stat == stat and effect.rounds == rounds and get_quality() == effect.get_quality():
			expire()
			boost = get_combined_boost(boost, effect.boost)
			apply()
			return true
	
	return false

func get_quality() -> EffectQuality:
	if boost >= 0.0:
		return EffectQuality.POSITIVE
	return EffectQuality.NEGATIVE

func randomize_effect() -> void:
	stat = ICONS.keys().pick_random()
	rounds = randi_range(1, 3)
	boost = randf_range(-0.25, 0.25)
	if boost > 0.0:
		quality = StatusEffect.EffectQuality.POSITIVE
	else:
		quality = StatusEffect.EffectQuality.NEGATIVE

func get_combined_boost(boost1: float, boost2: float) -> float:
	return boost1 + boost2
