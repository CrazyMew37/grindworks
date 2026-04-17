extends FloorModifier

const RANDOM_EFFECTS := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_regeneration.tres")

func modify_floor() -> void:
	BattleService.s_battle_started.connect(on_battle_start)

func on_battle_start(battle: BattleManager) -> void:
	for cog in battle.cogs:
		apply_effect(cog)
	battle.s_participant_joined.connect(func(participant):
		if participant is Cog:
			apply_effect(participant)
	)
	
	await Util.s_process_frame
	
	BattleService.s_refresh_statuses.emit()
	BattleService.ongoing_battle.battle_ui.cog_panels.reset(0)
	BattleService.ongoing_battle.battle_ui.cog_panels.assign_cogs(BattleService.ongoing_battle.cogs)

func apply_effect(cog: Cog) -> void:
	var effect: StatusEffect = RANDOM_EFFECTS.duplicate(true)
	effect.status_name = "Krusty Goodness"
	effect.icon = load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pocket_prank_icons/krabbypatty.png")
	effect.icon_scale = 0.8
	effect.target = cog
	effect.amount = ceili(cog.stats.max_hp * 0.1)
	effect.instant_effect = false
	effect.rounds = -1
	await Util.s_process_frame
	BattleService.ongoing_battle.add_status_effect(effect)

func get_mod_name() -> String:
	return "Krabby Patty Sale"

func get_mod_icon() -> Texture2D:
	return load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pause/krabbypattysale.png")

func get_description() -> String:
	return "Cogs gain HP regen equal to 10% of their HP."

func get_mod_quality() -> ModType:
	return ModType.NEGATIVE
