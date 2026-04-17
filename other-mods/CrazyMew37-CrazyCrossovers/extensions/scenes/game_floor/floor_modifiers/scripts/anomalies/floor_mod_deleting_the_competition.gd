extends FloorModifier

var ATTACK_AMOUNT := 0.01
var TOTAL_ATK := 0.00
const EARN_SFX := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/s_kill_glitch1.ogg")

## Gives player jellybeans for every Cog defeated
func modify_floor() -> void:
	BattleService.s_battle_started.connect(on_battle_start)

func on_battle_start(battle: BattleManager) -> void:
	battle.s_participant_died.connect(battle_participant_dying)

func battle_participant_dying(participant: Node3D) -> void:
	if participant is Cog and Util.get_player():
		if not BattleService.cog_gives_credit(participant):
			return
		if Util.floor_number > 5:
			ATTACK_AMOUNT = 0.01 * (1 + (floor((Util.floor_number - 1) / 5) * 0.5))
		Util.get_player().stats.damage += ATTACK_AMOUNT
		TOTAL_ATK += ATTACK_AMOUNT
		AudioManager.play_sound(EARN_SFX)
		Util.get_player().boost_queue.queue_text("Damage Up!", Color("fc954cff"))

func clean_up() -> void:
	Util.get_player().stats.damage -= TOTAL_ATK

func get_mod_name() -> String:
	return "Deleting the Competition"

func get_mod_quality() -> ModType:
	return ModType.POSITIVE

func get_mod_icon() -> Texture2D:
	return load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pause/deletingthecompetition.png")

func get_description() -> String:
	return "Every defeated cog will give you +1% Attack for the floor! (Stat increase goes up by +0.5% every five floors with Endless)"
