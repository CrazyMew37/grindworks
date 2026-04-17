@tool
extends StatusEffect
class_name StatBoostTetris

var ICONS := {
	'Toon-Up': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/battle/statuses/TetrominoT.png"),
	'Drop': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/battle/statuses/TetrominoI.png"),
	'Trap': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/battle/statuses/TetrominoO.png"),
	'Lure': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/battle/statuses/TetrominoS.png"),
	'Throw': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/battle/statuses/TetrominoL.png"),
	'Sound': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/battle/statuses/TetrominoJ.png"),
	'Squirt': load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/battle/statuses/TetrominoZ.png"),
}

@export var stat: String = 'Drop'
@export var boost: float = 0.2
var tetris_block: int = 7

func apply():
	# Applies a random Tetromino. 1: T/Toon-Up, 2: Z/Squirt, 3: O/Trap, 4: S/Lure, 5: J/Sound, 6: L/Throw, 6: I/Drop
	tetris_block = randi_range(1,7)
	if tetris_block == 1:
		stat = 'Toon-Up'
		BattleService.ongoing_battle.battle_stats[Util.get_player()].toonup_boost += boost
	elif tetris_block == 2:
		stat = 'Squirt'
	elif tetris_block == 3:
		stat = 'Trap'
	elif tetris_block == 4:
		stat = 'Lure'
	elif tetris_block == 5:
		stat = 'Sound'
	elif tetris_block == 6:
		stat = 'Throw'
	else:
		stat = 'Drop'
	if tetris_block > 1 and stat in Util.get_player().stats.gag_effectiveness:
		BattleService.ongoing_battle.battle_stats[Util.get_player()].gag_effectiveness[stat] += boost
	
func expire():
	if tetris_block == 1:
		BattleService.ongoing_battle.battle_stats[Util.get_player()].toonup_boost -= boost
	else:
		if stat in Util.get_player().stats.gag_effectiveness:
			BattleService.ongoing_battle.battle_stats[Util.get_player()].gag_effectiveness[stat] -= boost

func get_description() -> String:
	return "Boosts the damage/effects of {0} by {1}{2}%".format([stat, "+" if boost > 0.0 else "-", roundi(abs(boost) * 100)])

func get_icon() -> Texture2D:
	return ICONS[stat]

func get_status_name() -> String:
	return "{0} Tetromino Boost".format([stat])

func get_quality() -> EffectQuality:
	if boost >= 0.0:
		return EffectQuality.POSITIVE
	return EffectQuality.NEGATIVE
