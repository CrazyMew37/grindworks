@tool
extends StatusEffect

var turns_added := 2

func apply() -> void:
	if Util.on_easy_floor():
		turns_added = 1
	target.stats.turns = turns_added
	description = "Gains +1 move at the end of {0} round.\nCurrent extra round count: {1}".format(["every odd" if Util.on_easy_floor() else "every", (turns_added - 1)])
	manager.s_round_ended.connect(on_round_end)

func on_round_end() -> void:
	if Util.on_easy_floor():
		if manager.current_round % 2 == 1:
			turns_added += 1
			target.stats.turns = turns_added
	else:
		if manager.current_round % 1 == 0:
			turns_added += 1
			target.stats.turns = turns_added
	description = "Gains +1 move at the end of {0} round.\nCurrent extra round count: {1}".format(["every odd" if Util.on_easy_floor() else "every", (turns_added - 1)])

func cleanup() -> void:
	manager.s_round_ended.disconnect(on_round_end)
