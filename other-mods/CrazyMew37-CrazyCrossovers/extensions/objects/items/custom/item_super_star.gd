extends ItemScriptActive

const BOOST_AMT := 10000.0
const BOOST_TIME := 12.0
var STAR_COLORS := [Color(1.0, 0.0, 0.0, 1.0), Color(1.0, 0.5, 0.0, 1.0), Color(1.0, 1.0, 0.0, 1.0), Color(0.0, 1.0, 0.0, 1.0), Color(0.0, 1.0, 1.0, 1.0), Color(0.0, 0.5, 1.0, 1.0), Color(0.5, 0.0, 1.0, 1.0), Color(1.0, 0.0, 1.0, 1.0)]

const START_SFX := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/superstar.ogg")
const THEME := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/invincibletheme.ogg")

func use() -> void:
	AudioManager.play_sound(START_SFX)
	AudioManager.play_sound(THEME)
	Util.get_player().boost_queue.queue_text("Invincibility applied!", Color.GOLD)
	var stat_mult := StatMultiplier.new()
	stat_mult.stat = 'defense'
	stat_mult.amount = 10000.0
	stat_mult.additive = false
	Util.get_player().stats.multipliers.append(stat_mult)
	Task.delayed_call(TaskContainer, BOOST_TIME, Util.get_player().stats.multipliers.erase.bind(stat_mult))
	for colors in range(0,16):
		Util.get_player().toon.color_overlay_mat.flash_instant_fade(Util.get_player(), STAR_COLORS[colors % 8], 0.9, 0.5)
		await Task.delay(0.75)
	
