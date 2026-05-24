extends FloorModifier

var floor_mod := 0.3
const BOOST_STATS: Array[String] = ['damage', 'defense', 'evasiveness', 'luck', 'speed']
var multiplier := StatMultiplier.new()

func modify_floor() -> void:
	if Util.floor_number > 5:
		floor_mod = 0.3 * (1 + (floor((Util.floor_number - 1) / 5) * 0.5))
	multiplier.stat = get_lowest_stat()
	multiplier.additive = true
	multiplier.amount = floor_mod
	Util.get_player().stats.multipliers.append(multiplier)

func get_lowest_stat() -> String:
	var stats := Util.get_player().stats
	var current_stats := BOOST_STATS.map(func(stat): return stats.get_stat(stat))
	return BOOST_STATS[current_stats.find(current_stats.min())]

func clean_up() -> void:
	Util.get_player().stats.multipliers.erase(multiplier)

func get_mod_name() -> String:
	return "Inspiration"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/inspiration.png")

func get_description() -> String:
	if not multiplier or multiplier.stat.is_empty():
		return "Increases your lowest stat by 30% for this floor (Stat increase goes up by +15% every 5 floors)"
	else:
		return "Increases your lowest stat (" + multiplier.stat.to_pascal_case() + ") by 30% (Stat increase goes up by +15% every 5 floors)" 

## Override this for other objects to tell what type of mod it is
func get_mod_quality() -> ModType:
	return ModType.POSITIVE
