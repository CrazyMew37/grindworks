@tool
extends StatusEffect
class_name StatusTrapped

@export var gag: GagTrap

func get_status_name() -> String:
	return "Trapped (%s)" % gag.action_name

func get_description() -> String:
	return "Lure to activate the Trap"

func get_icon() -> Texture2D:
	return gag.icon

func renew() -> void:
	if not is_instance_valid(target) or target.stats.hp <= 0:
		return
	
	if not Util.get_player().trap_needs_lure and not target.lured:
		manager.battle_node.focus_character(target)
		gag.damage = manager.get_damage(gag.damage, gag, target)
		gag.activate()
		await gag.s_trap
