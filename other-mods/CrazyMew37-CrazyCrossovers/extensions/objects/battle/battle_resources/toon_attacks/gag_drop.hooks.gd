extends Object

var cc: Node = null

func get_stats(chain: ModLoaderHookChain) -> String:
	getCC()
	var string = "Damage: " + chain.reference_object.get_true_damage() + "\n"\
	+ "Affects: "
	match chain.reference_object.target_type:
		chain.reference_object.ActionTarget.SELF:
			string += "Self"
		chain.reference_object.ActionTarget.ENEMIES:
			string += "All Cogs"
		chain.reference_object.ActionTarget.ENEMY:
			string += "One Cog"
		chain.reference_object.ActionTarget.ENEMY_SPLASH:
			string += "Three Cogs"

	string += "\nAftershock: %s" % chain.reference_object.get_true_damage((0.5 + cc.aftershock_damage_boost))

	return string

func apply_debuff(chain: ModLoaderHookChain, target: Cog, damage_dealt: int) -> void:
	getCC()
	var new_effect: StatEffectAftershock = chain.reference_object.DEBUFF.duplicate(true)
	new_effect.amount = roundi(damage_dealt * (0.5 + cc.aftershock_damage_boost))
	new_effect.target = target
	if chain.reference_object.user.stats.get_stat("drop_aftershock_round_boost") != 0:
		new_effect.rounds += chain.reference_object.user.stats.get_stat("drop_aftershock_round_boost")
	chain.reference_object.manager.add_status_effect(new_effect)

func getCC() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	var root := tree.get_root()
	cc = root.get_node_or_null("/root/ModLoader/CrazyMew37-CrazyCrossovers/CCglobal")
