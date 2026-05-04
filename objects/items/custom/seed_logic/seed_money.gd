extends 'res://objects/items/custom/seed_logic/custom_seed_base.gd'

func _ready() -> void:
	Util.s_floor_started.connect(delete_dragon_wings)

func setup() -> void:
	Util.get_player().stats.money = 1000000
	ItemService.seen_item(load("res://objects/items/resources/accessories/backpacks/dragon_wings.tres"))
	await Util.s_floor_started
	Util.get_player().speak("What am I gonna spend all these jellybeans on?")
	
func delete_dragon_wings(_gfloor: GameFloor) -> void:
	ItemService.seen_item(load("res://objects/items/resources/accessories/backpacks/dragon_wings.tres"))
	print("Dragon Wings deleted, you goofball!")
