@tool
extends StatusEffect

func apply() -> void:
	manager.s_round_started.connect(on_round_started)

func on_round_started(_started) -> void:
	var cog: Cog = target
	if randi_range(1, 4) == 4:
		manager.skip_turn(cog)
		Util.get_player().boost_queue.queue_text("Cog Turn Skipped!", Color(0.659, 0.801, 0.89))

func cleanup() -> void:
	manager.s_round_started.disconnect(on_round_started)
