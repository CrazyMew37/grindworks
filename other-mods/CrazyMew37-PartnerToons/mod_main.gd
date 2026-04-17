extends Node

# ! Comments prefixed with "!" mean they are extra info. Comments without them
# ! should be kept because they give your mod structure and make it easier to
# ! read by other modders
# ! Comments with "?" should be replaced by you with the appropriate information

# ! This template file is statically typed. You don't have to do that, but it can help avoid bugs
# ! You can learn more about static typing in the docs
# ! https://docs.godotengine.org/en/3.5/tutorials/scripting/gdscript/static_typing.html

# ? Brief overview of what your mod does...

const MOD_DIR := "CrazyMew37-PartnerToons" # Name of the directory that this file is in
const LOG_NAME := "CrazyMew37-PartnerToons:Main" # Full ID of the mod (AuthorName-ModName)

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""


# ! your _ready func.
func _init() -> void:
	ModLoaderLog.info("Init", LOG_NAME)
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)
	
	# Add extensions
	install_script_extensions()
	install_script_hook_files()

	# Add translations
	add_translations()

func install_script_extensions() -> void:
	# ! any script extensions should go in this directory, and should follow the same directory structure as vanilla
	extensions_dir_path = mod_dir_path.path_join("extensions")

	#ModLoaderMod.install_script_extension(ext_dir + "entities/units/player/player.gd") # ! Note that this file does not exist in this example mod

	# ! Add extensions (longform version of the above)
	#ModLoaderMod.install_script_extension("res://mods-unpacked/AuthorName-ModName/extensions/main.gd")
	#ModLoaderMod.install_script_extension("res://mods-unpacked/AuthorName-ModName/extensions/entities/units/player/player.gd")


func install_script_hook_files() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")


func add_translations() -> void:
	# ! Place all of your translation files into this directory
	translations_dir_path = mod_dir_path.path_join("translations")


func _ready() -> void:
	ModLoaderLog.info("Ready", LOG_NAME)

	var item_paths := {
		# Accessories - cm37
		"partner_toon": "res://mods-unpacked/CrazyMew37-PartnerToons/partnertoon/roaming_toon/partner_toon.tres",
	}

	var pool_memberships := {
		"shop_rewards.tres": ["partner_toon",],
		"everything.tres": ["partner_toon",],
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
