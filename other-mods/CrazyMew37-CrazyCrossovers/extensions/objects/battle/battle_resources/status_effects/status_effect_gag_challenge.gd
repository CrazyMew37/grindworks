@tool
extends StatusEffect

# Pacesetter called. He wants his cheats back. -CM37
const GAG_BAN_EFFECT := preload('res://objects/battle/battle_resources/status_effects/resources/status_effect_gag_order.tres')
const PUNISHMENT_EFFECT := preload('res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/status_effects/status_effect_contest_punish.tres')

var logic_effect: StatusEffect
var player = Util.get_player()
var track_list: Array[Track]:
	get: return player.stats.character.gag_loadout.loadout
var trimmed_list: Array[Track] = []
var required_tracks: Track
var ban_effects: Array[StatusEffect] = []
var expires_this_round := false
var gag_used := false

# Called by battle manager on initial application
func apply():
	rounds = 0
	trimmed_list = track_list.duplicate(true)
	require_random_track(manager)
	BattleService.s_refresh_statuses.emit()
	BattleService.s_round_ended.connect(require_random_track)
	BattleService.s_round_started.connect(on_round_started)

func cleanup() -> void:
	for ban_effect: StatusEffect in ban_effects:
		if ban_effect and is_instance_valid(ban_effect):
			manager.expire_status_effect(ban_effect)
	BattleService.s_refresh_statuses.emit()
	BattleService.s_round_ended.disconnect(require_random_track)
	BattleService.s_round_started.disconnect(on_round_started)

func require_random_track(_manager: BattleManager) -> void:
	if manager.cogs.size() > 0:
		var loadout := Util.get_player().stats.character.gag_loadout
		var new_track = loadout.loadout.pick_random()
		required_tracks = new_track
		var new_effect := make_banned_effect(new_track.gags)
		manager.add_status_effect(new_effect)
		ban_effects.clear()
		ban_effects.append(new_effect)
		Util.get_player().boost_queue.queue_text("Use {0}!".format([required_tracks.track_name]), required_tracks.track_color)

func make_banned_effect(gags: Array[ToonAttack]) -> StatusEffect:
	var banned_effect := GAG_BAN_EFFECT.duplicate(true)
	banned_effect.rounds = 0
	banned_effect.target = player
	banned_effect.banned_color = Color.MAGENTA
	banned_effect.gags = gags
	return banned_effect

func on_round_started(actions: Array[BattleAction]) -> void:
	gag_used = false
	if rounds == 0:
		expires_this_round = true
	for effect in ban_effects:
		if not effect.is_banned_gag_used(actions):
			var punish_effect := PUNISHMENT_EFFECT.duplicate(true)
			punish_effect.rounds = 0
			punish_effect.target = player
			manager.add_status_effect(punish_effect)
			return
		if effect.is_banned_gag_used(actions) and gag_used == false:
			for action in actions:
				for gag in required_tracks.gags:
					if gag.action_name == action.action_name and gag_used == false:
						increase_damage(action)
				print("Gag{0}".format([required_tracks.track_name]))

func increase_damage(action: BattleAction) -> void:
	Util.get_player().boost_queue.queue_text("Good job! You used the right gag!", Color(0.567, 0.85, 0.0, 1.0))
	gag_used = true

func get_description() -> String:
	var desc := "Not using {0} will result in -25% Defense.".format([required_tracks.track_name])
	return desc
