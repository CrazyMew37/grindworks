@tool
extends StatusEffect

var player: Player:
	get: return Util.get_player()
var player_hp := 0

func apply() -> void:
	player_hp = player.stats.hp
	player.stats.hp_changed.connect(on_hp_change)

func on_hp_change(new_hp: int) -> void:
	if new_hp < player_hp and is_target_attacking():
		apply_effect()
	player_hp = new_hp

func is_target_attacking() -> bool:
	if not manager.current_action: return false
	
	return manager.current_action.user == target

func apply_effect() -> void:
	var cog: Cog = target
	
	player.stats.money = max(0, player.stats.money - cog.level)

func cleanup() -> void:
	player.stats.hp_changed.disconnect(on_hp_change)
