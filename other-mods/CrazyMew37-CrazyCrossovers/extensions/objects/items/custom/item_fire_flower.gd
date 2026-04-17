extends ItemScript

var POISON_EFFECT := load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/status_effects/status_effect_scorched.tres")
const EFFECT_RATIO := 0.35

func setup() -> void:
	BattleService.s_round_started.connect(on_round_started)

func on_round_started(actions : Array[BattleAction]) -> void:
	for action in actions:
		if action is GagThrow:
			action.s_hit.connect(throw_hit.bind(action))

func throw_hit(action : GagThrow) -> void:
	var gag_damage := BattleService.ongoing_battle.get_damage(action.damage, action, action.targets[0])
	var cog: Cog = action.targets[0]
	if cog.stats.hp > 0:
		apply_poison_effect(cog, get_damage(gag_damage))
		print("applied scorched!")

func apply_poison_effect(cog : Cog, damage : int) -> void:
	var poison_effect := POISON_EFFECT.duplicate(true)
	poison_effect.target = cog
	poison_effect.amount = damage
	poison_effect.rounds = 2
	poison_effect.icon = load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pocket_prank_icons/fireflower.png")
	BattleService.ongoing_battle.add_status_effect(poison_effect)
	print("applied scorched!")

func get_damage(gag_damage : int) -> int:
	return ceili(gag_damage * EFFECT_RATIO)

func on_collect(_item : Item, _model : Node3D) -> void:
	setup()

func on_load(_item : Item) -> void:
	setup()
