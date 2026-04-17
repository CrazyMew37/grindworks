extends ItemScript

func setup() -> void:
	BattleService.s_round_started.connect(on_round_start)

func on_round_start(actions: Array[BattleAction]) -> void:
	for action in actions.duplicate(true):
		if action is ToonAttack:
			if randf() < Util.get_relevant_player_stats().get_luck_weighted_chance(0.05, 0.15, 2.0):
				for cogaction in actions.duplicate(true):
					if cogaction is CogAttack and cogaction.user in action.targets:
						AudioManager.play_sound(load('res://audio/sfx/battle/cogs/attacks/SA_buzz_word.ogg'))
						Util.get_player().boost_queue.queue_text("Cog frozen!", Color(0.5, 0.7, 0.9, 1.0))
						BattleService.ongoing_battle.round_actions.erase(cogaction)
				for cog in BattleService.ongoing_battle.cogs:
					if not cog in BattleService.ongoing_battle.has_moved:
						BattleService.ongoing_battle.has_moved.append(cog)

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()
