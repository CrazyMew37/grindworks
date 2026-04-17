extends Object

const NEW_COG_CREATOR := "res://mods-unpacked/CrazyMew37-CogCreatorPlus/overwrites/cog_creator.tscn"

func open_cog_creator(chain: ModLoaderHookChain) -> void:
	if not chain.reference_object.active:
		return
	SceneLoader.load_into_scene(NEW_COG_CREATOR)
	chain.reference_object.hide()
	chain.reference_object.close()
