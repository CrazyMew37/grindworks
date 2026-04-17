extends ItemScript


func on_collect(_item: Item, _object: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_battle_started.connect(battle_started)
	
	var player: Player
	if not is_instance_valid(Util.get_player()):
		player = await Util.s_player_assigned
	else:
		player = Util.get_player()
	

func battle_started(battle: BattleManager) -> void:
	battle.s_round_started.connect(round_started)

func round_started(round_actions: Array[BattleAction]) -> void:
	var index := 0
	var seen_actions : Array[BattleAction] = []
	
	while index < round_actions.size():
		var action := round_actions[index]
		
		# Move all toon attacks to the back of the round actions
		if not action is ToonAttack or action in seen_actions:
			index += 1
			seen_actions.append(action)
		else:
			round_actions.remove_at(index)
			round_actions.append(action)
			seen_actions.append(action)
	
	BattleService.ongoing_battle.round_actions = round_actions
