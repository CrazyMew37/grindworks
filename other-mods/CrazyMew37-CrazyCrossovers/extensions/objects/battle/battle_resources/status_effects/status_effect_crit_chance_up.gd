@tool
extends StatusEffect
class_name StatusEffectCritChanceUp

@export var boost: float = 1.0
var user_cog: Cog

func apply() -> void:
	BattleService.s_action_started.connect(on_action_started)

func clean_up() -> void:
	BattleService.s_action_started.disconnect(on_action_started)

func on_action_started(action: BattleAction) -> void:
	if action is CogAttack and randf() < boost and action.user.global_position == target.global_position:
		action.crit_chance_mod = Globals.CRIT_MOD_GUARANTEE

func get_description() -> String:
	return "%s%s%% %s" % ["+" if boost > 0.0 else "-", roundi(abs(boost) * 100), "Crit Chance"]

func get_status_name() -> String:
	return "Crit Chance" + (" Up" if boost > 0.0 else " Down")

func combine(effect: StatusEffect) -> bool:
	if not effect is StatusEffectCritChanceUp:
		return false
	
	if force_no_combine or effect.force_no_combine:
		return false

	if effect is StatusEffectCritChanceUp:
		if effect.rounds == rounds and get_quality() == effect.get_quality():
			expire()
			boost = get_combined_boost(boost, effect.boost)
			apply()
			return true
	
	return false
	
func get_quality() -> EffectQuality:
	if boost >= 0.0:
		return EffectQuality.POSITIVE
	return EffectQuality.NEGATIVE

func get_combined_boost(boost1: float, boost2: float) -> float:
	return boost1 + boost2
