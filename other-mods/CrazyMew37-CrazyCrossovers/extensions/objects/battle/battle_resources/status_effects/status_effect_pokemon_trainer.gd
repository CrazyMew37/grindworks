@tool
extends StatusEffect

const IMMUNITIES := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_gag_immunity.tres")
const AFTERSHOCK_EFFECT := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_aftershock.tres")
const REINFORCEMENTS := preload("res://objects/battle/battle_resources/cog_attacks/resources/call_reinforcements.tres")

var applied = false

func apply() -> void:
	manager.s_participant_died.connect(on_participants_changed)
	manager.s_round_ended.connect(on_round_ended)
	var loadout := Util.get_player().stats.character.gag_loadout
	print(loadout.loadout)
	for gagtype in loadout.loadout:
		var immunity_effect := IMMUNITIES.duplicate(true)
		immunity_effect.rounds = -1
		immunity_effect.target = target
		immunity_effect.track = gagtype
		manager.add_status_effect(immunity_effect)

func on_round_ended() -> void:
	call_reinforcements()

func call_reinforcements() -> void:
	# Call Reinforcements: Whenever Ash is alone
	if manager.cogs.size() == 1 and target:
		var action := REINFORCEMENTS.duplicate(true)
		action.user = target
		action.cog_amount = 2
		action.targets = [target]
		BattleService.ongoing_battle.round_end_actions.append(action)

func on_participants_changed(_p) -> void:
	# people are gonna see that this is aftershock in disguise if you use drop :( -cm37
	# also bessie may totally cheese ash -cm37
	if manager.cogs.size() > 0 and target:
		var damage_effect := AFTERSHOCK_EFFECT.duplicate(true)
		damage_effect.rounds = 0
		damage_effect.target = target
		if Util.on_easy_floor():
			damage_effect.amount = ceili(target.stats.max_hp / 4)
		else:
			damage_effect.amount = ceili(target.stats.max_hp / 6)
			manager.add_status_effect(damage_effect)
		call_reinforcements()
