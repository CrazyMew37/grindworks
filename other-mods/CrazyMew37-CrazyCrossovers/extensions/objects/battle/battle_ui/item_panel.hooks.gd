extends Object

func get_pixie_desc(chain: ModLoaderHookChain) -> String:
	if Util.get_player().revives_are_hp:
		return "Cannot lose your last life"
	return "%s%% laff regeneration" % roundi(20.0 * Util.get_player().stats.healing_effectiveness * BattleService.ongoing_battle.battle_stats[Util.get_player()].toonup_boost)
