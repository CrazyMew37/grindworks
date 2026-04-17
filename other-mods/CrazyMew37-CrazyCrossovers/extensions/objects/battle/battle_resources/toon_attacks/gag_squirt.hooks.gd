extends Object

var cc: Node = null

# let's hope that Green Folio doesn't have a stroke -cm37
func apply_debuff(chain: ModLoaderHookChain, target: Cog) -> void:
	getCC()
	var new_effect: StatBoost = chain.reference_object.DEBUFF.duplicate(true)
	new_effect.target = target
	new_effect.rounds = 2 + cc.drenched_round_boost
	new_effect.boost = chain.reference_object.get_player_stats().get_stat('squirt_defense_boost')
	chain.reference_object.manager.add_status_effect(new_effect)
	
func getCC() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	var root := tree.get_root()
	cc = root.get_node_or_null("/root/ModLoader/CrazyMew37-CrazyCrossovers/CCglobal")
