extends Control


func _ready() -> void:
	AudioManager.stop_music(true)
	Util.get_player().queue_free()
	%ConnectingPanel.show()
	AudioManager.play_sound(load("res://audio/sfx/misc/XSCREAM2.ogg"))
	await Task.delay(1.5)
	get_tree().quit()
