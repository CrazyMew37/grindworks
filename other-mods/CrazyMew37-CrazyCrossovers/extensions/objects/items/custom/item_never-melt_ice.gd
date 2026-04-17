extends ItemScript

var player: Player
var cc : Node = null

func on_collect(_item: Item, _object: Node3D) -> void:
	getCC()
	setup(_item)
	
func on_load(_item: Item) -> void:
	getCC()

func getCC() -> void:
	var path := "/root/ModLoader/CrazyMew37-CrazyCrossovers/CCglobal"
	if get_tree().get_root().has_node(path):
		cc = get_tree().get_root().get_node(path)
		print("Loaded CCglobal")
	else:
		print("CCglobal not found at", path)

func on_item_removed() -> void:
	cc.drenched_round_boost += 1

func setup(_item: Item) -> void:
	cc.drenched_round_boost -= 1
	if not Util.get_player():
		await Util.s_player_assigned
	player = Util.get_player()
