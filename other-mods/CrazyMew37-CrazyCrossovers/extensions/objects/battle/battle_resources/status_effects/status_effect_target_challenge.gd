@tool
extends StatusEffect

const REPRIMAND := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/status_effects/status_effect_contest_punish.tres")

var was_targeted := false

func apply():
	manager.s_round_started.connect(round_started)
	manager.s_round_ended.connect(round_ended)

func round_started(actions: Array[BattleAction]) -> void:
	for action: BattleAction in actions:
		if action is ToonAttack and not action.special_action_exclude:
			if target in action.targets:
				was_targeted = true
				Util.get_player().boost_queue.queue_text("Good job! You attacked the right cog!", Color(0.567, 0.85, 0.0, 1.0))
				print("target challenge: targeted")
				break
	handle_expiry_target_logic()

func round_ended() -> void:
	was_targeted = false

func cleanup() -> void:
	if manager.s_round_started.is_connected(round_started):
		manager.s_round_started.disconnect(round_started)

func handle_expiry_target_logic() -> void:
	if was_targeted == false:
		# Add reprimand attack if we don't meet the conditions
		create_reprimand_attack()

func create_reprimand_attack() -> void:
	var attack_boost = REPRIMAND.duplicate(true)
	attack_boost.target = Util.get_player()
	manager.add_status_effect(attack_boost)
