extends FloorModifier

var NERF_AMT_PLAYER := -0.25
const NERF_AMT_COGS := -0.25

var status_effect: StatBoost:
	get: return GameLoader.load("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres").duplicate(true)

func modify_floor() -> void:
	if Util.floor_number > 5:
		NERF_AMT_PLAYER = -0.25 * (1 + (floor((Util.floor_number - 1) / 5) * 0.5))
	var player := Util.get_player()
	player.stats.damage += NERF_AMT_PLAYER
	game_floor.s_cog_spawned.connect(on_cog_spawned)

func clean_up() -> void:
	var player := Util.get_player()
	player.stats.damage -= NERF_AMT_PLAYER
	game_floor.s_cog_spawned.disconnect(on_cog_spawned)

func on_cog_spawned(cog: Cog) -> void:
	cog.s_dna_set.connect(on_dna_set.bind(cog))

func on_dna_set(cog: Cog) -> void:
	var effect := status_effect
	effect.boost = NERF_AMT_COGS
	effect.rounds = -1
	effect.quality = StatusEffect.EffectQuality.NEGATIVE
	effect.stat = 'damage'
	cog.status_effects.append(effect)
	pass

func get_mod_name() -> String:
	return "Eclipse"

func get_mod_quality() -> ModType:
	return ModType.NEUTRAL

func get_mod_icon() -> Texture2D:
	return load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/player_ui/pause/smeclipse.png")

func get_description() -> String:
	return "Everyone receives -25% Damage (Your damage goes down by an extra -12.5% every five floors)"
