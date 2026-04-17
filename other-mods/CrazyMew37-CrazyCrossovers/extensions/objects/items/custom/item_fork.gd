extends ItemScript

const EVASIVENESS_BOOST := 0.02

func on_collect(_item: Item, _object: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_cog_dealt_damage.connect(_on_damage_dealt)

func _on_damage_dealt(action: BattleAction, target: Node3D, amount: int) -> void:
	if action is CogAttack and target == Util.get_player() and amount > 0:
		var new_action := ActionScriptCallable.new()
		new_action.callable = hurt_cog
		new_action.add_tag(BattleAction.ActionTag.IS_DEFLECT_ATTACK)
		new_action.user = BattleService.ongoing_battle.battle_node
		new_action.targets = [action.user]
		new_action.damage = ceili(action.damage)
		BattleService.ongoing_battle.inject_battle_action(new_action, 0)
		
func hurt_cog() -> void:
	var manager := BattleService.ongoing_battle
	var battle_node := manager.battle_node
	var targets := manager.current_action.targets
	var damage: int = ceili(manager.current_action.damage * 1.5 * Util.get_player().stats.damage)
	
	manager.show_action_name("Forked!")
	var cog: Cog = targets[0]
	BattleService.ongoing_battle.battle_node.focus_character(cog)
	cog.set_animation('pie-small')
	manager.affect_target(cog, damage)
	AudioManager.play_sound(load("res://audio/sfx/battle/cogs/attacks/special/tt_s_ara_cfg_toonHit.ogg"))
	await Task.delay(3.0)
	
	await manager.check_pulses(targets)
