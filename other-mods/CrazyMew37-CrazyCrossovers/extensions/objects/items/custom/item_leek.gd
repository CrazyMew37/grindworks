extends ItemScriptActive

const AFTERSHOCK := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_aftershock.tres")
const SFX_PRESS := preload("res://audio/sfx/battle/gags/AA_trigger_box.ogg")
const BUTTON := preload("res://models/props/gags/button/toon_button.tscn")
const LEEK := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/objects/items/custom/leek_animated.tscn")
const DROP_SHADOW := preload("res://objects/misc/drop_shadow/drop_shadow.tscn")
const SFX_FALL := preload("res://audio/sfx/battle/gags/drop/incoming_whistleALT.ogg")
const SFX_HIT := preload("res://audio/sfx/battle/gags/drop/AA_drop_sandbag.ogg")

func use() -> void:
	BattleService.ongoing_battle.battle_ui.cog_panels.reset(0)
	await cutscene(BattleService.ongoing_battle.cogs)
	BattleService.ongoing_battle.battle_ui.cog_panels.assign_cogs(BattleService.ongoing_battle.cogs)

func cutscene(cogs : Array[Cog]) -> void:
	var player := Util.get_player()
	var battle := BattleService.ongoing_battle
	var battle_node := battle.battle_node
	
	if is_instance_valid(battle.battle_ui.timer):
		battle.battle_ui.timer.timer.set_paused(true)
		
	battle.battle_ui.visible = false
	
	battle.battle_node.battle_cam.position -= Vector3(0, 3, 1)
	battle.battle_node.battle_cam.rotation_degrees += Vector3(35,0,0)
	
	var button := BUTTON.instantiate()
	
	player.toon.left_hand_bone.add_child(button)
	player.state = Player.PlayerState.STOPPED
	
	var tween1 := create_tween()
	tween1.tween_callback(player.set_animation.bind('press-button'))
	tween1.tween_interval(2.3)
	tween1.tween_callback(AudioManager.play_sound.bind(SFX_PRESS))
	
	for cog in cogs:
		tween1.tween_callback(affect_cog.bind(cog))
	
	tween1.tween_interval(3.0)
	tween1.finished.connect(button.queue_free)
	
	await Task.delay(2.9)
	
	await tween1.finished
	tween1.kill()
		
	battle.battle_ui.visible = true
	Util.get_player().toon.show()
	battle.battle_node.focus_character(battle.battle_node)
	
	if is_instance_valid(battle.battle_ui.timer):
		battle.battle_ui.timer.timer.set_paused(false)

func affect_cog(cog: Cog) -> void:
	var drop_shadow := DROP_SHADOW.instantiate()
	drop_shadow.scale *= 0.01
	drop_shadow.position.y += 0.05
	cog.add_child(drop_shadow)
	var prop := LEEK.instantiate()
	
	var demote_tween := create_tween()
	demote_tween.tween_callback(AudioManager.play_sound.bind(SFX_FALL, -10.0))
	demote_tween.tween_property(drop_shadow, 'scale', Vector3.ONE * 1.5, 2.0)
	demote_tween.tween_callback(AudioManager.play_sound.bind(SFX_HIT))
	demote_tween.tween_callback(apply_aftershock.bind(cog))
	demote_tween.tween_callback(cog.set_animation.bind('anvil-drop'))
	demote_tween.tween_callback(parent_prop.bind(cog, prop))
	demote_tween.tween_callback(prop.get_node('AnimationPlayer').play.bind('drop'))
	demote_tween.tween_callback(drop_shadow.queue_free)
	demote_tween.tween_interval(3.0)
	demote_tween.finished.connect(
	func():
		demote_tween.kill()
		prop.queue_free()
	)

func parent_prop(cog: Cog, prop: Node3D) -> void:
	cog.body.add_child(prop)
	prop.global_position = cog.body.head_bone.global_position
	prop.position.y -= (1.0 if cog.dna.suit == CogDNA.SuitType.SUIT_C else 2.0)

func apply_aftershock(cog: Cog) -> void:
	# Apply the drenched effect
	var aftershock = AFTERSHOCK.duplicate(true)
	aftershock.amount = (cog.level * 4)
	aftershock.rounds = (3 + Util.get_player().stats.drop_aftershock_round_boost)
	aftershock.target = cog
	BattleService.ongoing_battle.add_status_effect(aftershock)
	Util.do_3d_text(cog, "Leeked!")
