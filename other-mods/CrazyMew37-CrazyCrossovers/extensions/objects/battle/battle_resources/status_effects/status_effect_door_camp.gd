@tool
extends StatusEffect

const REPRIMAND := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/cog_attacks/jumpscare.tres")
const STAT_BOOSTS := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")
var ATTACK_INCREASE_AMOUNT := 0.35

var was_targeted := false

func apply():
	manager.s_round_started.connect(round_started)
	manager.s_round_ended.connect(round_ended)
	description = "Target and damage this cog or else they will {0}".format(["attack twice and gain a +25% damage boost!" if Util.on_easy_floor() else "attack twice and gain a +35% damage boost!"])


func round_started(actions: Array[BattleAction]) -> void:
	for action: BattleAction in actions:
		if action is ToonAttack and not action.special_action_exclude:
			# to prevent lure from cheesing the fight -CM37
			if action is not GagLure:
				if target in action.targets:
					was_targeted = true
					print("door camp: targeted")
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
	if Util.on_easy_floor():
		ATTACK_INCREASE_AMOUNT = 0.25
	var attack_boost = STAT_BOOSTS.duplicate(true)
	attack_boost.target = target
	attack_boost.rounds = -1
	attack_boost.stat = "damage"
	if sign(ATTACK_INCREASE_AMOUNT) == 1:
		attack_boost.quality = StatusEffect.EffectQuality.POSITIVE
	else:
		attack_boost.quality = StatusEffect.EffectQuality.NEGATIVE
	attack_boost.boost = ATTACK_INCREASE_AMOUNT
	manager.add_status_effect(attack_boost)
	var reprimand := REPRIMAND.duplicate(true)
	reprimand.user = target
	reprimand.targets = [Util.get_player()]
	manager.round_end_actions.append(reprimand)
