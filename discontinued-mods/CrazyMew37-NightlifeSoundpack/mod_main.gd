extends Node

# ! Comments prefixed with "!" mean they are extra info. Comments without them
# ! should be kept because they give your mod structure and make it easier to
# ! read by other modders
# ! Comments with "?" should be replaced by you with the appropriate information

# ! This template file is statically typed. You don't have to do that, but it can help avoid bugs
# ! You can learn more about static typing in the docs
# ! https://docs.godotengine.org/en/3.5/tutorials/scripting/gdscript/static_typing.html

# ? Brief overview of what your mod does...

const MOD_DIR := "CrazyMew37-NightlifeSoundpack" # Name of the directory that this file is in
const LOG_NAME := "CrazyMew37-NightlifeSoundpack:Main" # Full ID of the mod (AuthorName-ModName)

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""


# ! your _ready func.
func vanilla_4267401125__init() -> void:
	ModLoaderLog.info("Init", LOG_NAME)
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)

	# Add extensions
	install_script_extensions()
	install_script_hook_files()

	# Add translations
	add_translations()


func vanilla_4267401125_install_script_extensions() -> void:
	# ! any script extensions should go in this directory, and should follow the same directory structure as vanilla
	extensions_dir_path = mod_dir_path.path_join("extensions")

	#ModLoaderMod.install_script_extension(ext_dir + "entities/units/player/player.gd") # ! Note that this file does not exist in this example mod

	# ! Add extensions (longform version of the above)
	#ModLoaderMod.install_script_extension("res://mods-unpacked/AuthorName-ModName/extensions/main.gd")
	#ModLoaderMod.install_script_extension("res://mods-unpacked/AuthorName-ModName/extensions/entities/units/player/player.gd")


func vanilla_4267401125_install_script_hook_files() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")


func vanilla_4267401125_add_translations() -> void:
	# ! Place all of your translation files into this directory
	translations_dir_path = mod_dir_path.path_join("translations")


func vanilla_4267401125__ready() -> void:
	ModLoaderLog.info("Ready", LOG_NAME)

	# ! This uses Godot's native `tr` func, which translates a string. You'll
	# ! find this particular string in the example CSV here: translations/modname.csv
	ModLoaderLog.info("Translation Demo: " + tr("MODNAME_READY_TEXT"), LOG_NAME)


# ModLoader Hooks - The following code has been automatically added by the Godot Mod Loader.


func _init():
	if _ModLoaderHooks.any_mod_hooked:
		_ModLoaderHooks.call_hooks(vanilla_4267401125__init, [], 1361345624)
	else:
		vanilla_4267401125__init()


func install_script_extensions():
	if _ModLoaderHooks.any_mod_hooked:
		_ModLoaderHooks.call_hooks(vanilla_4267401125_install_script_extensions, [], 2661958591)
	else:
		vanilla_4267401125_install_script_extensions()


func install_script_hook_files():
	if _ModLoaderHooks.any_mod_hooked:
		_ModLoaderHooks.call_hooks(vanilla_4267401125_install_script_hook_files, [], 2668991570)
	else:
		vanilla_4267401125_install_script_hook_files()


func add_translations():
	if _ModLoaderHooks.any_mod_hooked:
		_ModLoaderHooks.call_hooks(vanilla_4267401125_add_translations, [], 2213354607)
	else:
		vanilla_4267401125_add_translations()


func _ready():
	if _ModLoaderHooks.any_mod_hooked:
		_ModLoaderHooks.call_hooks(vanilla_4267401125__ready, [], 1985073369)
	else:
		vanilla_4267401125__ready()
