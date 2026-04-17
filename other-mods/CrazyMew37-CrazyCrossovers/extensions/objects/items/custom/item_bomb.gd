extends ItemScriptActive

const STAT_BOOST_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")
const SFX := preload("res://audio/sfx/battle/cogs/ENC_cogfall_apart.ogg")
const ROUNDS := 0
const BOOST_AMT := 0.2
const COST := -0.2
var BombActive := false

func validate_use() -> bool:
	if BombActive == false:
		return true
	else:
		return false

func use() -> void:
	BattleService.ongoing_battle.battle_ui.cog_panels.reset(0)
	await cutscene(BattleService.ongoing_battle.player)
	BattleService.ongoing_battle.battle_ui.cog_panels.assign_cogs(BattleService.ongoing_battle.cogs)

func cutscene(player: Player) -> void:
	BombActive = true
	if is_instance_valid(BattleService.ongoing_battle.battle_ui.timer):
		BattleService.ongoing_battle.battle_ui.timer.timer.set_paused(true)
		
	BattleService.ongoing_battle.battle_ui.visible = false
	BattleService.battle_node.focus_character(Util.get_player())
	AudioManager.play_sound(SFX)
	var stat_boost := STAT_BOOST_REFERENCE.duplicate(true)
	stat_boost.quality = StatusEffect.EffectQuality.POSITIVE
	stat_boost.stat = 'damage'
	stat_boost.boost = BOOST_AMT
	stat_boost.rounds = ROUNDS
	stat_boost.target = player
	BattleService.ongoing_battle.add_status_effect(stat_boost)
	player.quick_heal(floori(player.stats.max_hp * COST), false)
	player.set_animation('slip-backward')
	player.last_damage_source = "an explosive personality"
	player.boost_queue.queue_text("KABOOM!", Color(0.7, 0.07, 0.07, 1.0))
	var kaboom := Sprite3D.new()
	kaboom.render_priority = 1
	kaboom.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	kaboom.texture = load('res://models/props/gags/tnt/kaboom.png')
	player.add_child(kaboom)
	kaboom.global_position = player.global_position
	kaboom.scale *= 0.25
	var kaboom_tween := kaboom.create_tween()
	kaboom_tween.tween_property(kaboom,'pixel_size',.05,1.0)
	await kaboom_tween.finished
	kaboom_tween.kill()
	kaboom.queue_free()
	await BattleService.ongoing_battle.sleep(2.0)
	if player.stats.hp > 0:
		BattleService.ongoing_battle.battle_ui.visible = true
		BattleService.ongoing_battle.battle_node.focus_character(BattleService.ongoing_battle.battle_node)
		player.set_animation('neutral')
		BombActive = false
	if is_instance_valid(BattleService.ongoing_battle.battle_ui.timer):
		BattleService.ongoing_battle.battle_ui.timer.timer.set_paused(false)
	BattleService.s_refresh_statuses.emit()
	BattleService.ongoing_battle.check_pulses([player])
