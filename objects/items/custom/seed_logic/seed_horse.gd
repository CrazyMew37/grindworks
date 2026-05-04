extends 'res://objects/items/custom/seed_logic/custom_seed_base.gd'


var secret_dna: ToonDNA:
	get: return load("res://objects/items/custom/seed_logic/horsie_dna.tres")
var accessories: Array[String] = [
	"res://objects/items/resources/accessories/hats/cowboy_hat.tres",
	"res://objects/items/resources/accessories/glasses/aviator_glasses.tres",
]


func setup() -> void:
	Util.get_player().character.dna.species = ToonDNA.ToonSpecies.HORSE
	Globals.s_shop_spawned.connect(on_shop_spawned)

func on_shop_spawned(shop: ToonShop) -> void:
	if shop.toon and shop.toon_speaks:
		transform_toon(shop.toon)

func transform_toon(toon: Toon) -> void:
	toon.construct_toon(secret_dna)
	for path in accessories:
		var accessory: ItemAccessory = load(path)
		accessory.place_accessory(toon)
		var shoe: ItemShoe = load("res://objects/items/resources/accessories/shoes/cowboy_boots.tres")
		shoe.place_shoes(toon)
	toon.set_animation('neutral')
