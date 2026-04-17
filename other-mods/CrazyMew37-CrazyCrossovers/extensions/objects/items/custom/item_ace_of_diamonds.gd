extends ItemScript

const STAT_BOOST_REFERENCE := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/battle/battle_resources/status_effects/status_effect_stat_boost_card.tres")

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
	on_round_end(manager)

func on_round_end(_manager: BattleManager) -> void:
	var boost_amount := randi_range(65,135) * 0.01
	var stat_boost := STAT_BOOST_REFERENCE.duplicate(true)
	stat_boost.stat = "defense"
	stat_boost.boost = boost_amount
	if boost_amount >= 1.0:
		stat_boost.quality = StatusEffect.EffectQuality.POSITIVE
	else:
		stat_boost.quality = StatusEffect.EffectQuality.NEGATIVE
	stat_boost.rounds = 0
	stat_boost.target = player
	BattleService.ongoing_battle.add_status_effect(stat_boost)
