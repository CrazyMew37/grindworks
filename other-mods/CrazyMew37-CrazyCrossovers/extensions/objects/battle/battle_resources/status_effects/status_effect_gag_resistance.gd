@tool
extends StatusEffect

@export var boost := 0.5
@export var gag_type := "Throw"

const ICONS: Dictionary = {
	"Trap": preload("res://ui_assets/battle/statuses/trap_immunity.png"),
	"Lure": preload("res://ui_assets/battle/statuses/lure_immunity.png"),
	"Sound": preload("res://ui_assets/battle/statuses/sound_immunity.png"),
	"Squirt": preload("res://ui_assets/battle/statuses/squirt_immunity.png"),
	"Throw": preload("res://ui_assets/battle/statuses/throw_immunity.png"),
	"Drop": preload("res://ui_assets/battle/statuses/drop_immunity.png"),
}

var player := Util.get_player()
var track_list: Array[Track]:
	get: return player.stats.character.gag_loadout.loadout
var trimmed_list: Array[Track] = []
var required_tracks: Track
var ban_effects: Array[StatusEffect] = []

func apply() -> void:
	trimmed_list = track_list.duplicate(true)
	required_tracks = player.stats.character.gag_loadout.get_track_of_name(gag_type)
	BattleService.s_refresh_statuses.emit()
	BattleService.s_round_started.connect(on_round_started)

func cleanup() -> void:
	BattleService.s_refresh_statuses.emit()
	BattleService.s_round_started.disconnect(on_round_started)

func on_round_started(actions: Array[BattleAction]) -> void:
	for action in actions:
		if action is ToonAttack and target in action.targets:
			for gag in required_tracks.gags:
				if gag.action_name == action.action_name:
					increase_damage(action)
					print("Gag{0}".format([required_tracks.track_name]))

func increase_damage(action: BattleAction) -> void:
	action.damage *= boost
	if action is GagLure:
		action.lure_effect.knockback_effect *= boost

func get_status_name() -> String:
	return "{0} {1}".format([gag_type, "Weakness" if boost > 1.0 else "Resistance"])

func get_quality() -> EffectQuality:
	if boost >= 1.0:
		return EffectQuality.NEGATIVE
	return EffectQuality.POSITIVE

func get_description() -> String:
	var desc := "{0} will be {1}% effective on this cog.".format([required_tracks.track_name, roundi(abs(boost) * 100)])
	return desc

func get_icon() -> Texture2D:
	if boost >= 1.0:
		icon_color = Color(0.66,1,0.66,1.0)
	else:
		icon_color = Color(1,0.66,0.66,1.0)
	if ICONS[gag_type]:
		return ICONS[gag_type]
	else:
		return load("res://ui_assets/battle/statuses/track_immunity.png")
