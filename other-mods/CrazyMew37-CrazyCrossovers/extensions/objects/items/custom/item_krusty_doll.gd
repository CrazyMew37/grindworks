extends ItemScriptActive

const SFX_LAUGH := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/krusty-laugh.ogg")
const SFX_BOMB := preload("res://audio/sfx/battle/cogs/ENC_cogfall_apart.ogg")
const SFX_COG_BOOM := preload("res://audio/sfx/misc/tt_s_ara_mat_crash_glassBoing.ogg")
const DAMAGE := -0.35
const NUKE_CHANCE := 0.05
const DAMAGE_CHANCE := 0.25

func use() -> void:
	AudioManager.play_sound(SFX_LAUGH)
	var _roll := RNG.channel(RNG.ChannelPhilosophersStoneRolls).randf()
	var _chance := Util.get_player().stats.get_luck_weighted_chance(NUKE_CHANCE, NUKE_CHANCE * 2, 2.0)
	var _chance2 := Util.get_player().stats.get_luck_weighted_chance(DAMAGE_CHANCE, DAMAGE_CHANCE * 0.5, 2.0)
	if _roll > (1 - _chance):
		nuke_cogs()
	elif _roll < _chance2:
		damage_toon()
	else:
		Util.get_player().boost_queue.queue_text("Pocket Prank Failed!", Color.CHOCOLATE)

func nuke_cogs() -> void:
	BattleService.ongoing_battle.battle_ui.cog_panels.reset(0)
	await nuke_cutscene(BattleService.ongoing_battle.cogs)
	BattleService.ongoing_battle.battle_ui.cog_panels.assign_cogs(BattleService.ongoing_battle.cogs)

func nuke_cutscene(cogs : Array[Cog]) -> void:
	var player := Util.get_player()
	var battle := BattleService.ongoing_battle
	var battle_node := battle.battle_node
	
	if is_instance_valid(battle.battle_ui.timer):
		battle.battle_ui.timer.timer.set_paused(true)
		
	battle.battle_ui.visible = false
	
	Util.get_player().boost_queue.queue_text("Time to clown around!", Color.LAWN_GREEN)
	
	battle.battle_node.battle_cam.position -= Vector3(0, 3, 1)
	battle.battle_node.battle_cam.rotation_degrees += Vector3(35,0,0)
	
	player.state = Player.PlayerState.STOPPED
	AudioManager.play_sound(SFX_COG_BOOM)
	
	for cog in cogs:
		affect_cog(cog)
	
	await Task.delay(2.75)
	
	BattleService.ongoing_battle.check_pulses(cogs)
	
	await Task.delay(6.0)
	
	BattleService.ongoing_battle.battle_ui.selected_gags.clear()
	
	BattleService.ongoing_battle.battle_ui.complete_turn()

func affect_cog(cog: Cog) -> void:
	var demote_tween := create_tween()
	demote_tween.tween_callback(cog.set_animation.bind('pie-small'))
	demote_tween.tween_callback(func(): cog.stats.hp = 0)
	demote_tween.tween_interval(2.5)
	demote_tween.finished.connect(
	func():
		demote_tween.kill()
	)

func damage_toon() -> void:
	BattleService.ongoing_battle.battle_ui.cog_panels.reset(0)
	await damage_cutscene(BattleService.ongoing_battle.player)
	BattleService.ongoing_battle.battle_ui.cog_panels.assign_cogs(BattleService.ongoing_battle.cogs)

func damage_cutscene(player: Player) -> void:
	if is_instance_valid(BattleService.ongoing_battle.battle_ui.timer):
		BattleService.ongoing_battle.battle_ui.timer.timer.set_paused(true)
		
	BattleService.ongoing_battle.battle_ui.visible = false
	BattleService.battle_node.focus_character(Util.get_player())
	AudioManager.play_sound(SFX_BOMB)
	player.quick_heal(floori(player.stats.max_hp * DAMAGE), false)
	player.set_animation('slip-backward')
	player.last_damage_source = "a Krusty Doll"
	player.boost_queue.queue_text("The jokes on you!", Color.CRIMSON)
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
	if is_instance_valid(BattleService.ongoing_battle.battle_ui.timer):
		BattleService.ongoing_battle.battle_ui.timer.timer.set_paused(false)
	BattleService.s_refresh_statuses.emit()
	BattleService.ongoing_battle.check_pulses([player])
