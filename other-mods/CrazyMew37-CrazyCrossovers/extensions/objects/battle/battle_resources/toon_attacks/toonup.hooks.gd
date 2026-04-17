extends Object

func apply(chain: ModLoaderHookChain, target: Player) -> void:
	var sfx: AudioStream
	if chain.reference_object.movie_type == chain.reference_object.MovieType.LADDER:
		sfx = chain.reference_object.SFX_LADDER
		for stat_effect in chain.reference_object.get_ladder_effects():
			stat_effect.target = target
			if not is_equal_approx(BattleService.ongoing_battle.battle_stats[Util.get_player()].toonup_boost, 1.0):
				stat_effect.boost *= BattleService.ongoing_battle.battle_stats[Util.get_player()].toonup_boost
			BattleService.ongoing_battle.add_status_effect(stat_effect)
	else:
		sfx = chain.reference_object.SFX_USE
		if chain.reference_object.status_effect:
			var new_effect: StatusEffect = chain.reference_object.get_status_effect_copy(chain.reference_object.status_effect)
			new_effect.is_toonup_effect = true
			new_effect.force_no_combine = true
			new_effect.target = target
			if not is_equal_approx(BattleService.ongoing_battle.battle_stats[Util.get_player()].toonup_boost, 1.0):
				if new_effect is StatBoost:
					new_effect.boost *= BattleService.ongoing_battle.battle_stats[Util.get_player()].toonup_boost
				elif new_effect is StatusEffectGagDiscount:
					new_effect.discount = roundi(float(new_effect.discount) * BattleService.ongoing_battle.battle_stats[Util.get_player()].toonup_boost)
			if not chain.reference_object.try_combine(new_effect):
				BattleService.ongoing_battle.add_status_effect(new_effect)

	var unite: GPUParticles3D = load('res://objects/battle/effects/unite/unite.tscn').instantiate()
	Util.get_player().add_child(unite)
	AudioManager.play_sound(Util.get_player().toon.yelp)
	AudioManager.play_sound(sfx)
	BattleService.s_refresh_statuses.emit()

## Get properly registered version of regeneration
func get_regen(chain: ModLoaderHookChain, regen: StatEffectRegeneration) -> StatEffectRegeneration:
	var new_regen = chain.reference_object.REGEN_REFERENCE.duplicate(true)
	new_regen.status_name = "Pixie Dust"
	new_regen.amount = regen.amount
	new_regen.instant_effect = regen.instant_effect
	new_regen.rounds = chain.reference_object.BASE_ROUND_COUNT + Util.get_player().stats.toonup_round_boost
	new_regen.icon = load("res://ui_assets/battle/statuses/investment_cog_heal.png")
	new_regen.description = "%s%% laff regeneration" % roundi(20.0 * Util.get_player().stats.healing_effectiveness)
	new_regen.amount = ceili(Util.get_player().stats.max_hp * 0.2 * BattleService.ongoing_battle.battle_stats[Util.get_player()].toonup_boost)
	new_regen.description = "%.d%% Laff Regeneration" % (0.2 * BattleService.ongoing_battle.battle_stats[Util.get_player()].toonup_boost * 100)
	BattleService.ongoing_battle.affect_target(Util.get_player(), -new_regen.amount)
	return new_regen
