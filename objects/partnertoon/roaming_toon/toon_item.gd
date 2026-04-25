extends Node3D

const FAKE_EVERGREEN_ENABLED := true
const ITEM_PATH := 'res://objects/partnertoon/roaming_toon/partner_toon.tres'

## Doodle obj
@onready var doodle : RoamingToon = $RoamingToon

var possible_descriptions: Array[String] = [
	"SOS!",
]

func _ready():
	doodle.state = RoamingToon.DoodleState.STOPPED

func setup(item: Item):
	if item.item_name == 'Partner Toon':
		roll_for_name(item)
	
	## Double check that there is definitely no other doodles available
	#for resource in ItemService.items_in_play:
		#if resource.item_description in possible_descriptions:
			#if not resource == item:
				#item.reroll()
	
	# Item is evergreen so that it can have arbitrary data.
	# This script will still put the item into seen
	#if FAKE_EVERGREEN_ENABLED:
		#ItemService.seen_item(load(ITEM_PATH))

func roll_for_name(item: Item) -> void:
	var new_name := Globals.get_random_toon_name()
	item.item_name = new_name
	item.item_description = possible_descriptions[RNG.channel(RNG.ChannelDoodleDescriptions).randi() % possible_descriptions.size()]

func modify(model: Node3D):
	model.get_child(0).state = RoamingToon.DoodleState.STOPPED
	model.get_child(0).toon.toon_dna = doodle.toon.toon_dna
	model.get_child(0).toon.construct_toon(doodle.toon.toon_dna)

func custom_collect():
	Util.get_player().partners.append(doodle)
	SceneLoader.add_persistent_node(doodle)
	doodle.rotation = Vector3(0,0,0)
	doodle.state = RoamingToon.DoodleState.NAVIGATE
	doodle.following_player = true
	Globals.s_partner_toon_obtained.emit()
