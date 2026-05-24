extends FloorModifier

var floor_mod := -0.2
const BOOST_STATS: Array[String] = ['damage', 'defense', 'evasiveness', 'luck', 'speed']
var multiplier := StatMultiplier.new()

func modify_floor() -> void:
	if Util.floor_number > 5:
		floor_mod = 0.2 * (1 + (floor((Util.floor_number - 1) / 5) * 0.5))
	multiplier.stat = get_highest_stat()
	multiplier.additive = true
	multiplier.amount = floor_mod
	Util.get_player().stats.multipliers.append(multiplier)

func get_highest_stat() -> String:
	var stats := Util.get_player().stats
	var current_stats := BOOST_STATS.map(func(stat): return stats.get_stat(stat))
	return BOOST_STATS[current_stats.find(current_stats.max())]

func clean_up() -> void:
	Util.get_player().stats.multipliers.erase(multiplier)

func get_mod_name() -> String:
	return "Stagnation"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/stagnation.png")

func get_description() -> String:
	if not multiplier or multiplier.stat.is_empty():
		return "Decreases your highest stat by 20% for this floor (Stat decrease goes up by +10% every 5 floors)"
	else:
		return "Decreases your highest stat (" + multiplier.stat.to_pascal_case() + ") by 20% (Stat decrease goes up by +10% every 5 floors)" 

## Override this for other objects to tell what type of mod it is
func get_mod_quality() -> ModType:
	return ModType.POSITIVE
