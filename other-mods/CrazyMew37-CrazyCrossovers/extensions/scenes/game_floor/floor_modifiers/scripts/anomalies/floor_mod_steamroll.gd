extends FloorModifier

var SPEED_AMOUNT := 0.01
const EARN_SFX := preload("res://audio/sfx/objects/stomper/CHQ_FACT_stomper_raise.ogg")

func modify_floor() -> void:
	BattleService.s_battle_ending.connect(on_battle_end)

func on_battle_end() -> void:
	if Util.floor_number > 5:
		SPEED_AMOUNT = 0.01 * (1 + (floor((Util.floor_number - 1) / 5) * 0.5))
	Util.get_player().stats.speed += SPEED_AMOUNT
	Util.get_player().boost_queue.queue_text("Speed Up!", Color("fba697ff"))
	AudioManager.play_snippet(EARN_SFX, 0.0, 1.25, 3.0)

func get_mod_name() -> String:
	return "Steamroll"

func get_mod_quality() -> ModType:
	return ModType.POSITIVE

func get_mod_icon() -> Texture2D:
	return load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pause/steamroll.png")

func get_description() -> String:
	return "Every cleared battle will earn you +1% Speed (Stat increase goes up by +0.5% every five floors with Endless)"
