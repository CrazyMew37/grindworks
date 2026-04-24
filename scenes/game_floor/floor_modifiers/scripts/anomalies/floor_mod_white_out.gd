extends FloorModifier


func modify_floor() -> void:
	var env : Environment = game_floor.environment.environment.duplicate(true)
	env.background_energy_multiplier = 0.05
	env.fog_enabled = true
	env.fog_density = 0.02
	env.fog_light_color = Color('ddddff')
	game_floor.environment.environment = env
	game_floor.environment.environment.ambient_light_color = Color('bbbbff')


func get_mod_name() -> String:
	return "White Out"

func get_mod_quality() -> ModType:
	return ModType.NEGATIVE
