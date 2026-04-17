extends ItemScriptActive

const SFX := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/terapagoscry.ogg")
var STAT_DIFF_POS := 0.05

# AM I THE MAIN CHARACTER OF THIS STORY?! -Likat

func use() -> void:
	AudioManager.play_sound(SFX)
	var track_choice: Track = RNG.channel(RNG.ChannelBeeHiveHairdoStats).pick_random(Util.get_player().character.gag_loadout.loadout)
	Util.get_player().stats.gag_effectiveness[track_choice.track_name] += 0.05
	Util.get_player().boost_queue.queue_text("%s Up!" % [track_choice.track_name], track_choice.track_color.lerp(Color.WHITE, 0.2))
