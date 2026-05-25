extends ItemScriptActive

const STAT_BOOST_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost_crit.tres")

func use() -> void:
	var battle_manager: BattleManager = BattleService.ongoing_battle
	
	if is_instance_valid(battle_manager):
		Util.get_player().boost_queue.queue_text("Guaranteed Crits!", Color.GREEN)
		battle_manager.s_round_started.connect(guarantee_crits, CONNECT_ONE_SHOT)
		var stat_boost := STAT_BOOST_REFERENCE.duplicate(true)
		stat_boost.quality = StatusEffect.EffectQuality.POSITIVE
		stat_boost.stat = "crit_mult"
		stat_boost.boost = 0.25
		stat_boost.rounds = 0
		stat_boost.target = Util.get_player()
		BattleService.ongoing_battle.add_status_effect(stat_boost)
		BattleService.s_refresh_statuses.emit()

func guarantee_crits(actions: Array[BattleAction]) -> void:
	for action in actions:
		if action is ToonAttack:
			if not is_equal_approx(action.crit_chance_mod, 0.0):
				action.crit_chance_mod = Globals.CRIT_MOD_GUARANTEE
