extends ItemScriptActive

const BOOST_TIME := 8.0

const SFX := preload("res://audio/sfx/battle/cogs/misc/ENC_propeller_out.ogg")

func use() -> void:
	AudioManager.play_sound(SFX)
	Util.get_player().boost_queue.queue_text("Jump Boost!", Color.AQUA)
	Util.get_player().stats.agility += 0.2
	Util.get_player().stats.extra_jumps += 1
	Task.delayed_call(TaskContainer, BOOST_TIME, func():
		Util.get_player().stats.agility -= 0.2
		Util.get_player().stats.extra_jumps -= 1)
