extends 'res://objects/items/custom/seed_logic/custom_seed_base.gd'

func _ready() -> void:
	Util.s_floor_started.connect(delete_dragon_wings)

func setup() -> void:
	Util.get_player().stats.money = 1000000
	ItemService.seen_item(load("res://objects/items/resources/accessories/backpacks/dragon_wings.tres"))
	await Util.s_floor_started
	Util.get_player().speak("What am I gonna spend all these jellybeans on?")
	remove_wings_from_inventory()
	
func delete_dragon_wings(_gfloor: GameFloor) -> void:
	ItemService.seen_item(load("res://objects/items/resources/accessories/backpacks/dragon_wings.tres"))
	print("Dragon Wings deleted from the pools, you goofball!")
	remove_wings_from_inventory()
	
func remove_wings_from_inventory() -> void:
	if Util.get_player().stats.has_item('Dragon Wings') or Util.get_player().stats.has_item('Gold Ring'):
		for item in Util.get_player().stats.items:
			if item.item_name == 'Dragon Wings' or item.item_name == 'Gold Ring':
				item.remove_item(Util.get_player())
				print("Dragon Wings snapped! Rip Teto.")
