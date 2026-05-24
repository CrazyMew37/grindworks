@tool
extends StatusEffect

var turns_added = 0

func apply() -> void:
	manager.s_round_started.connect(on_round_started)
	manager.s_round_ended.connect(on_round_end)

func on_round_started(actions: Array[BattleAction]) -> void:
	if randi_range(1, 4) == 4:
		var insert_index := 0
		turns_added = 1
		while insert_index < actions.size() and not actions[insert_index].user == target:
			insert_index += 1
		if insert_index < actions.size():
			if actions[insert_index].user == target:
				for move in turns_added:
					manager.inject_battle_action(manager.get_cog_attack(target), insert_index)
					Util.get_player().boost_queue.queue_text("+1 Cog Turn!", Color(0.89, 0.747, 0.659, 1.0))
		target.stats.turns += turns_added

func on_round_end() -> void:
	target.stats.turns -= turns_added
	turns_added = 0
	
func cleanup() -> void:
	manager.s_round_started.disconnect(on_round_started)
	manager.s_round_ended.disconnect(on_round_end)
