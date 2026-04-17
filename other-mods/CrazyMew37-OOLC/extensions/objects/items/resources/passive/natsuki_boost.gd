extends ItemScript

var player: Player
var _last_hp: int

func on_collect(_item: Item, _object: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	player = Util.get_player()
	_last_hp = player.stats.hp
	BattleService.s_battle_started.connect(battle_started)
	BattleService.s_battle_ended.connect(battle_ended)

func battle_started(_battle: BattleManager) -> void:
	player.stats.hp_changed.connect(on_hp_changed)

func battle_ended() -> void:
	player.stats.hp_changed.disconnect(on_hp_changed)

func on_hp_changed(new_hp: int) -> void:
	if new_hp < _last_hp:
		var stat_boost := load("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres").duplicate(true)
		stat_boost.quality = StatusEffect.EffectQuality.POSITIVE
		stat_boost.stat = "damage"
		stat_boost.boost = 0.05
		stat_boost.rounds = 1
		stat_boost.target = player
		BattleService.ongoing_battle.add_status_effect(stat_boost)

	_last_hp = new_hp
