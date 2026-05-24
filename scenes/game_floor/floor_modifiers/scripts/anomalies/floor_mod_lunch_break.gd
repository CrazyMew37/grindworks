extends FloorModifier

var status_effect: StatusEffect:
	get: return GameLoader.load("res://objects/battle/battle_resources/status_effects/resources/status_effect_lunch_break.tres").duplicate(true)

func modify_floor() -> void:
	game_floor.s_cog_spawned.connect(on_cog_spawned)

func clean_up() -> void:
	game_floor.s_cog_spawned.disconnect(on_cog_spawned)

func on_cog_spawned(cog: Cog) -> void:
	cog.s_dna_set.connect(on_dna_set.bind(cog))

func on_dna_set(cog: Cog) -> void:
	var effect := status_effect
	effect.rounds = -1
	effect.quality = StatusEffect.EffectQuality.NEGATIVE
	cog.status_effects.append(effect)
	pass

func get_mod_name() -> String:
	return "Lunch Break"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/lunchbreak.png")

func get_description() -> String:
	return "Cogs have a 25% chance to skip their turn."

func get_mod_quality() -> ModType:
	return ModType.POSITIVE
