extends ItemScript

func on_collect(_item: Item, _object: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_battle_ended.connect(battle_ended)

func battle_ended() -> void:
	Util.get_player().quick_heal(int(ceil(Util.get_player().stats.max_hp * 0.05)))
