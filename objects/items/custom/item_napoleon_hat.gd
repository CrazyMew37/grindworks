extends ItemScript

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()
 
func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_action_started.connect(on_action_start)

func on_action_start(action: BattleAction) -> void:
	if action is ToonAttack:
		for target in action.targets:
			if target is Cog:
				boost_gag(action)

func boost_gag(action: ToonAttack) -> void:
	var scale_average := 0.0
	var cog_count := 0
	for target in action.targets:
		if target is Cog:
			scale_average += target.dna.scale
			cog_count += 1
	scale_average /= maxf(cog_count, 1.0)
	var boost := (0.7 + (scale_average * 0.075))
	action.damage = roundi(float(action.damage) * boost)
