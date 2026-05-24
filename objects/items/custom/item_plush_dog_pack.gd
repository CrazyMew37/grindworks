extends ItemScript

const STAT_BOOST := "res://objects/battle/battle_resources/status_effects/resources/status_effect_regeneration.tres"
const BOOST_AMT := 0.1

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_round_started.connect(on_round_start)

func on_round_start(actions: Array[BattleAction]) -> void:
	for action in actions:
		if action is ToonAttack and not action.special_action_exclude:
			return
	apply_boost()

func apply_boost() -> void:
	var boost: StatEffectRegeneration = load(STAT_BOOST).duplicate(true)
	boost.amount = floori(BOOST_AMT * (Util.get_player().stats.max_hp))
	boost.rounds = 1
	boost.instant_effect = false
	boost.quality = StatusEffect.EffectQuality.POSITIVE
	boost.target = Util.get_player()
	BattleService.ongoing_battle.add_status_effect(boost)
