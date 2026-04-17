extends ItemScript

const STAT_BOOST_REFERENCE := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/status_effects/status_effect_puyo_stat_boost.tres")

var current_stat = 0.0
var player: Player:
	get: return Util.get_player()

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_battle_started.connect(on_battle_start)
	BattleService.s_round_ended.connect(on_round_end)
	
func on_battle_start(manager: BattleManager) -> void:
	current_stat = 0.0
	on_round_end(manager)

func on_round_end(_manager: BattleManager) -> void:
	if current_stat < 0.48:
		var stat_boost := STAT_BOOST_REFERENCE.duplicate(true)
		stat_boost.quality = StatusEffect.EffectQuality.POSITIVE
		stat_boost.stat = "damage"
		stat_boost.boost = 0.02
		stat_boost.rounds = -1
		stat_boost.target = player
		BattleService.ongoing_battle.add_status_effect(stat_boost)
		current_stat += 0.02
