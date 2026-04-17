extends FloorModifier

var player: Player
var _last_hp: int

var BEAN_DECREASE := -1
const DMG_SFX := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/ring_lose.ogg")

## Player loses a bean if they take damage
func modify_floor() -> void:
	if Util.floor_number > 5:
		BEAN_DECREASE = -1 * floor(1 + ((Util.floor_number - 1) / 5))
	player = Util.get_player()
	_last_hp = player.stats.hp
	player.stats.hp_changed.connect(on_hp_changed)

func on_hp_changed(new_hp: int) -> void:
	if new_hp < _last_hp and Util.get_player().stats.money > 0:
		Util.get_player().stats.add_money(BEAN_DECREASE)
		AudioManager.play_sound(DMG_SFX)
	_last_hp = new_hp

func get_mod_name() -> String:
	return "Jellyrings"

func get_mod_quality() -> ModType:
	return ModType.NEGATIVE

func get_mod_icon() -> Texture2D:
	return load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pause/jellyrings.png")

func get_description() -> String:
	return "Lose 1 jellybean every time you take damage. (Jellybeans lost increases every five floors with Endless)"
