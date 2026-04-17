extends Node

const MOD_DIR := "CrazyMew37-CrazyCrossovers"
const LOG_NAME := "CrazyMew37-CrazyCrossovers:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""


func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)
	# Add extensions
	install_script_extensions()
	install_script_hook_files()

	# Add translations
	add_translations()

	#add "global class"
	_add_global_class()

func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("objects/general_ui/settings_menu/settings_menu.gd"))

func install_script_hook_files() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	print("installing script hooks")
	ModLoaderMod.install_script_hooks("res://objects/globals/save_file_service.gd", extensions_dir_path.path_join("objects/globals/save_file_service.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/battle/battle_resources/status_effects/stat_boost.gd", extensions_dir_path.path_join("objects/battle/battle_resources/status_effects/stat_boost.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/player/player.gd", extensions_dir_path.path_join("objects/player/player.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/battle/battle_resources/toon_attacks/gag_squirt.gd", extensions_dir_path.path_join("objects/battle/battle_resources/toon_attacks/gag_squirt.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/battle/battle_resources/toon_attacks/gag_sound.gd", extensions_dir_path.path_join("objects/battle/battle_resources/toon_attacks/gag_sound.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/battle/battle_resources/toon_attacks/gag_throw.gd", extensions_dir_path.path_join("objects/battle/battle_resources/toon_attacks/gag_throw.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/cog/cog.gd", extensions_dir_path.path_join("objects/cog/cog.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/battle/battle_resources/toon_attacks/gag_drop.gd", extensions_dir_path.path_join("objects/battle/battle_resources/toon_attacks/gag_drop.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/battle/battle_resources/toon_attacks/toonup.gd", extensions_dir_path.path_join("objects/battle/battle_resources/toon_attacks/toonup.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/battle/battle_ui/item_panel.gd", extensions_dir_path.path_join("objects/battle/battle_ui/item_panel.hooks.gd"))

func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")

func _add_global_class():
	var global_instance = load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/CCglobal.gd").new()
	global_instance.name = "CCglobal"
	add_child(global_instance)

func _ready() -> void:
	var settingsConfig := ModLoaderConfig.get_config("CrazyMew37-CrazyCrossovers", "crossoversettings")
	if not settingsConfig:
		settingsConfig == ModLoaderConfig.create_config("CrazyMew37-CrazyCrossovers", "crossoversettings", {
			"endlessnerfs": 0,
		})
	
	Globals.ADDITIONAL_TOON_PATHS.append("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/player/character/quacksane_teto.tres")
	Globals.ADDITIONAL_TOON_PATHS.append("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/player/character/jerry_fitzgerbil.tres")
	Globals.ADDITIONAL_TOON_PATHS.append("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/player/character/cartooncle.tres")
	Globals.ADDITIONAL_TOON_PATHS.append("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/player/character/the_blue_blur.tres")
	Globals.ADDITIONAL_TOON_PATHS.append("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/player/character/orbunon.tres")
	Globals.ADDITIONAL_TOON_PATHS.append("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/player/character/sailor_moonkey.tres")
	Globals.ADDITIONAL_TOON_PATHS.append("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/player/character/stewie_grizzly.tres")
	Globals.ADDITIONAL_TOON_PATHS.append("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/player/character/ace_of_steeds.tres")
	Globals.ADDITIONAL_TOON_PATHS.append("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/player/character/likat.tres")
	Globals.ADDITIONAL_TOON_PATHS.append("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/player/character/toony_pig.tres")

	print("crazy crossovers ACTIVATED!!!!!!!!!!!!!!!")

	var item_paths := {
		# Accessories - cm37
		"yoylecake": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/yoylecake.tres",
		"sodaroni": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/sodaroni.tres",
		"sun": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/sun.tres",
		"krabby_patty": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/krabby_patty.tres",
		"gold_ring": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/gold_ring.tres",
		"mushroom": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/mushroom.tres",
		"egg": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/egg.tres",
		"tnt_block": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/tnt_block.tres",
		"bubble_blower": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/bubble_blower.tres",
		"snowball": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/snowball.tres",
		"electric_guitar": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/electric_guitar.tres",
		"fire_flower": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/fire_flower.tres",
		"never-melt_ice": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/never-melt_ice.tres",
		"fork": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/fork.tres",
		"green_puyo": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/green_puyo.tres",
		"blue_puyo": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/blue_puyo.tres",
		"purple_puyo": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/purple_puyo.tres",
		"red_puyo": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/red_puyo.tres",
		"yellow_puyo": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/yellow_puyo.tres",
		"garbage_puyo": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/garbage_puyo.tres",
		"microgame_cartridge": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/microgame_cartridge.tres",
		"portrait_of_markov": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/portrait_of_markov.tres",
		"hot_sauce": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/hot_sauce.tres",
		"big_root": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/big_root.tres",
		"garlic_bottle": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/garlic_bottle.tres",
		"airy_crown": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/airy_crown.tres",
		"watery_crown": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/watery_crown.tres",
		"fiery_crown": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/fiery_crown.tres",
		"earthy_crown": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/earthy_crown.tres",
		"aethereal_crown": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/aethereal_crown.tres",
		"transformation_brooch": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/transformation_brooch.tres",
		"tetrominoes": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/tetrominoes.tres",
		"ace_of_spades": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/ace_of_spades.tres",
		"ace_of_hearts": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/ace_of_hearts.tres",
		"ace_of_diamonds": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/ace_of_diamonds.tres",
		"ace_of_clubs": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/ace_of_clubs.tres",
		"rupert": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/rupert.tres",
		"spatula": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/spatula.tres",
		"three-eyed_fish": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/three-eyed_fish.tres",
		"apple": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/apple.tres",
		"kendama": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/kendama.tres",
		"mr_cupcake": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/mr_cupcake.tres",
		"emerald": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/emerald.tres",
		"donut": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/donut.tres",
		"cat_cupcake": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/cat_cupcake.tres",
		"slingshot": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/slingshot.tres",
		"river_crystals": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/river_crystals.tres",
		"15_pip_die": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/15_pip_die.tres",
		"kelp_shake": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/kelp_shake.tres",
		"popsicle": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/passive/popsicle.tres",
		# Pocket Pranks - cm37
		"freddy_mask": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/freddy_mask.tres",
		"chaos_emerald": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/chaos_emerald.tres",
		"exotic_butters": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/exotic_butters.tres",
		"leek": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/leek.tres",
		"poke_ball": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/poke_ball.tres",
		"great_ball": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/great_ball.tres",
		"ultra_ball": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/ultra_ball.tres",
		"master_ball": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/master_ball.tres",
		"super_star": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/super_star.tres",
		"potion": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/potion.tres",
		"super_potion": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/super_potion.tres",
		"hyper_potion": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/hyper_potion.tres",
		"pen": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/pen.tres",
		"candy_bar_bag_carrying_bag": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/candy_bar_bag_carrying_bag.tres",
		"shovel": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/shovel.tres",
		"rose": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/rose.tres",
		"moon_stick": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/moon_stick.tres",
		"bomb": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/bomb.tres",
		"spaghetti": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/spaghetti.tres",
		"keyblade": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/keyblade.tres",
		"krusty_doll": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/krusty_doll.tres",
		"terastal_pendant": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/terastal_pendant.tres",
		"pacifier": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/pacifier.tres",
		"sling_scope": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/sling_scope.tres",
		"ham": "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/resources/active/ham.tres",
	}

	var pool_memberships := {
		"stranger_items.tres": ["sun","freddy_mask","chaos_emerald","ultra_ball","master_ball","electric_guitar","fire_flower","fork","super_star","garbage_puyo","microgame_cartridge","shovel","moon_stick","bomb","keyblade","tetrominoes","ace_of_spades","ace_of_hearts","ace_of_diamonds","ace_of_clubs","mr_cupcake","15_pip_die","rupert",],
		"special_items.tres": ["sun","gold_ring","egg","chaos_emerald","exotic_butters","master_ball","fork","super_star","microgame_cartridge","pen","keyblade","terastal_pendant","mr_cupcake","emerald","15_pip_die",],
		"shop_rewards.tres": ["yoylecake","sodaroni","krabby_patty","exotic_butters","leek","poke_ball","great_ball","fire_flower","rose","spaghetti","garlic_bottle","airy_crown","watery_crown","fiery_crown","earthy_crown","krusty_doll","sling_scope","donut","river_crystals","kelp_shake","popsicle",],
		"shop_progressives.tres": ["potion","super_potion","hyper_potion",],
		"rewards.tres": ["krabby_patty","great_ball","ultra_ball","green_puyo","blue_puyo","purple_puyo","red_puyo","yellow_puyo","super_potion","hyper_potion","candy_bar_bag_carrying_bag","shovel","moon_stick","aethereal_crown","ace_of_spades","ace_of_hearts","ace_of_diamonds","ace_of_clubs","pacifier","spatula","three-eyed_fish","bubble_blower","kendama","sling_scope","ham","emerald",],
		"progressives.tres": ["potion","super_potion","yoylecake","sodaroni","tnt_block","freddy_mask","poke_ball","snowball","never-melt_ice","mushroom","leek","rose","bomb","spaghetti","portrait_of_markov","hot_sauce","big_root","garlic_bottle","airy_crown","watery_crown","fiery_crown","earthy_crown","transformation_brooch","krusty_doll","pacifier","apple","donut","cat_cupcake","slingshot","river_crystals","kelp_shake","popsicle",],
		"item_roll_fails.tres": ["potion","super_potion","hyper_potion",],
		"floor_clears.tres": ["mushroom","egg","electric_guitar","green_puyo","blue_puyo","purple_puyo","red_puyo","yellow_puyo","garbage_puyo","portrait_of_markov","hot_sauce","big_root","aethereal_crown","tetrominoes","spatula","three-eyed_fish","bubble_blower","kendama","slingshot","rupert",],
		"everything.tres": ["yoylecake","sodaroni","sun","freddy_mask","krabby_patty","gold_ring","mushroom","egg","tnt_block","chaos_emerald","exotic_butters","leek","poke_ball","great_ball","ultra_ball","master_ball","bubble_blower","snowball","electric_guitar","fire_flower","never-melt_ice","fork","super_star","green_puyo","blue_puyo","purple_puyo","red_puyo","yellow_puyo","garbage_puyo","potion","super_potion","hyper_potion","microgame_cartridge","pen","candy_bar_bag_carrying_bag","shovel","rose","moon_stick","bomb","spaghetti","portrait_of_markov","hot_sauce","big_root","garlic_bottle","airy_crown","watery_crown","fiery_crown","earthy_crown","aethereal_crown","keyblade","transformation_brooch","tetrominoes","krusty_doll","ace_of_spades","ace_of_hearts","ace_of_diamonds","ace_of_clubs","terastal_pendant","pacifier","rupert","spatula","three-eyed_fish","apple","kendama","mr_cupcake","sling_scope","ham","emerald","donut","cat_cupcake","slingshot","river_crystals","15_pip_die","kelp_shake","popsicle",],
		"doodle_treasure.tres": ["sodaroni","tnt_block","potion","super_potion","hyper_potion","emerald","slingshot",],
		"battle_clears.tres": ["potion",],
		"active_items.tres": ["freddy_mask","chaos_emerald","exotic_butters","leek","poke_ball","great_ball","ultra_ball","master_ball","super_star","potion","super_potion","hyper_potion","pen","candy_bar_bag_carrying_bag","shovel","rose","moon_stick","bomb","spaghetti","keyblade","krusty_doll","terastal_pendant","pacifier","sling_scope","ham",],
		"accessories.tres": ["yoylecake","sodaroni","sun","krabby_patty","gold_ring","mushroom","egg","tnt_block","bubble_blower","snowball","electric_guitar","fire_flower","never-melt_ice","fork","green_puyo","blue_puyo","purple_puyo","red_puyo","yellow_puyo","garbage_puyo","microgame_cartridge","portrait_of_markov","hot_sauce","big_root","garlic_bottle","airy_crown","watery_crown","fiery_crown","earthy_crown","aethereal_crown","transformation_brooch","tetrominoes","ace_of_spades","ace_of_hearts","ace_of_diamonds","ace_of_clubs","rupert","spatula","three-eyed_fish","apple","kendama","mr_cupcake","emerald","donut","cat_cupcake","slingshot","river_crystals","15_pip_die","kelp_shake","popsicle",],
	}

	for pool_name in pool_memberships:
		var pool: Object = ItemService.pool_from_path("res://objects/items/pools/%s" % pool_name)
		if not pool:
			push_error("Missing pool: %s" % pool_name)

		for item_name in pool_memberships[pool_name]:
			var item_path = item_paths.get(item_name, "")
			if item_path and item_path not in pool.items:
				pool.items.append(item_path)
				var item = load(item_path)
				if item:
					print("Added %s to %s" % [item.item_name, pool_name])
				else:
					push_error("Failed to load item at: %s" % item_path)
					
	var anomaly_paths := {
		"positive": [
			"res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_deleting_the_competition.gd",
			"res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_shiny_chests.gd",
			"res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_steamroll.gd",
			"res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_triple_mushroom.gd",
		],
		"neutral": [
			"res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_eclipse.gd",
			"res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_elemental_enigma.gd",
			"res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_cutaway_gags.gd",
			"res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_graveyard_shift.gd",
		],
		"negative": [
			"res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_jellyrings.gd",
			"res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_cloudy_day.gd",
			"res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_cog_chaining.gd",
			"res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_krabby_patty_sale.gd",
		],
	}
	
	for anomaly in anomaly_paths["positive"]:
		if anomaly not in FloorVariant.ANOMALIES_POSITIVE:
			FloorVariant.ANOMALIES_POSITIVE.append(anomaly)
			print("Added positive anomaly: %s" % anomaly)
			
	for anomaly in anomaly_paths["neutral"]:
		if anomaly not in FloorVariant.ANOMALIES_NEUTRAL:
			FloorVariant.ANOMALIES_NEUTRAL.append(anomaly)
			print("Added neutral anomaly: %s" % anomaly)
			
	for anomaly in anomaly_paths["negative"]:
		if anomaly not in FloorVariant.ANOMALIES_NEGATIVE:
			FloorVariant.ANOMALIES_NEGATIVE.append(anomaly)
			print("Added negative anomaly: %s" % anomaly)
			
	Util.s_floor_started.connect(load_boss_rooms)
	
var add_boss_rooms = true

# Add the crossover boss rooms here, you idiot. -cm37
# The Mint is mint_floor_variant, DA Office, is da_floor_variant, and CGC is cgc_floor variant. -cm37
func load_boss_rooms(_game_floor: GameFloor) -> void:
	if add_boss_rooms == true:
		var miku_boss_room := FacilityRoom.new()
		miku_boss_room.room = "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/modules/factory/miku_boss_room.tscn"
		miku_boss_room.rarity_weight = 0.5
		Globals.factory_floor_variant.floor_type.final_rooms.append(miku_boss_room)
		
		var freddy_boss_room := FacilityRoom.new()
		freddy_boss_room.room = "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/modules/factory/freddy_boss_room.tscn"
		freddy_boss_room.rarity_weight = 0.5
		Globals.factory_floor_variant.floor_type.final_rooms.append(freddy_boss_room)
		
		var krabs_boss_room := FacilityRoom.new()
		krabs_boss_room.room = "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/modules/mint/mr_krabs_boss.tscn"
		krabs_boss_room.rarity_weight = 0.5
		Globals.mint_floor_variant.floor_type.final_rooms.append(krabs_boss_room)
		
		var bowser_boss_room := FacilityRoom.new()
		bowser_boss_room.room = "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/modules/mint/bowser_boss.tscn"
		bowser_boss_room.rarity_weight = 0.5
		Globals.mint_floor_variant.floor_type.final_rooms.append(bowser_boss_room)
		
		var ddlc_boss_room := FacilityRoom.new()
		ddlc_boss_room.room = "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/modules/office/ddlc_boss.tscn"
		ddlc_boss_room.rarity_weight = 0.5
		Globals.da_floor_variant.floor_type.final_rooms.append(ddlc_boss_room)
		
		var announcer_boss_room := FacilityRoom.new()
		announcer_boss_room.room = "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/modules/office/announcer_boss.tscn"
		announcer_boss_room.rarity_weight = 0.5
		Globals.da_floor_variant.floor_type.final_rooms.append(announcer_boss_room)
		
		var arle_boss_room := FacilityRoom.new()
		arle_boss_room.room = "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/modules/cgc/arle_boss.tscn"
		arle_boss_room.rarity_weight = 0.5
		Globals.cgc_floor_variant.floor_type.final_rooms.append(arle_boss_room)
		
		var ash_boss_room := FacilityRoom.new()
		ash_boss_room.room = "res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/modules/cgc/ash_boss.tscn"
		ash_boss_room.rarity_weight = 0.5
		Globals.cgc_floor_variant.floor_type.final_rooms.append(ash_boss_room)
		
		print("cc boss rooms added")
		add_boss_rooms = false
