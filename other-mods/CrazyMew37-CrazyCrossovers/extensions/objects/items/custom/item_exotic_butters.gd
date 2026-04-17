extends ItemScriptActive

# easiest script of the bunch. can i get my paycheck now? -cm37
func use() -> void:
	AudioManager.play_sound(load('res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/Exotic_Butters.ogg'))
