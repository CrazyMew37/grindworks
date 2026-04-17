extends ItemScript

const EARN_SFX := preload("res://audio/sfx/ui/tick_counter.ogg")

func on_collect(_item: Item, _object: Node3D) -> void:
	Util.get_player().stats.add_money(25)
	AudioManager.play_sound(EARN_SFX)
