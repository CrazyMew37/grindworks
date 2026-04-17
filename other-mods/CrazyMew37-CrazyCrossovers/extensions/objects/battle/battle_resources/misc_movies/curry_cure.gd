@tool
extends CogAttack

const LIABILITY_WAIVER: StatEffectRegeneration = preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_regeneration.tres")

const PAPER := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/models/props/currycookingmama.glb")
const PAPER_2 := preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/models/props/currycookingmama.glb")
const PaperPos = Vector3(-0.007, -0.731, 0.059)
const PaperRot = Vector3(22.5, 147.1, -29.7)
const PaperScale = Vector3.ONE * 0.7

const SFX_PAPER_PULL_OUT := preload("res://audio/sfx/misc/target_impact_only.ogg")
const SFX_PAPER_HIT := preload("res://audio/sfx/misc/MG_sfx_travel_game_no_bonus.ogg")

var response_lines: Array[String] = [
	"Mmm! Deeee-licious!",
	"Since when did you start sharing, Carby?",
	"Nothing beats a good bowl of curry!",
	"Now I can properly enjoy this battle!",
	"A little soon for a victory feast, ay, Carby?"
]

func action() -> void:
	# Get target Cog
	if targets.is_empty():
		return
	
	var target_cog: Cog = targets[0]

	var paper := PAPER.instantiate()
	var paper_2 := PAPER_2.instantiate()
	user.body.right_hand_bone.add_child(paper)
	paper.position = PaperPos
	paper.rotation_degrees = PaperRot
	paper.scale = PaperScale
	user.body.right_hand_bone.add_child(paper_2)
	paper_2.position = PaperPos
	paper_2.rotation_degrees = PaperRot
	paper_2.scale = PaperScale

	# Focus Cog
	user.set_animation('throw-paper')
	battle_node.focus_character(user)
	AudioManager.play_sound(SFX_PAPER_PULL_OUT)
	
	await manager.sleep(2.4)

	paper.reparent(battle_node)
	paper_2.reparent(battle_node)
	await user.get_tree().process_frame
	var new_pos: Vector3 = target_cog.body.nametag_node.global_position + Vector3(0, 3, 0)
	var final_pos: Vector3 = target_cog.body.nametag_node.global_position + Vector3(0, -2, 0)
	var new_pos_2: Vector3 = user.body.nametag_node.global_position + Vector3(0, 3, 0)
	var final_pos_2: Vector3 = user.body.nametag_node.global_position + Vector3(0, -2, 0)
	var projectile := Sequence.new([
		Parallel.new([
			LerpProperty.new(paper, ^"global_position", 1.0, new_pos).interp(Tween.EASE_OUT, Tween.TRANS_QUAD),
			LerpProperty.new(paper_2, ^"global_position", 1.0, new_pos_2).interp(Tween.EASE_OUT, Tween.TRANS_QUAD)
		]),
		Parallel.new([
			LerpProperty.new(paper, ^"global_rotation", 0.4, Vector3(90, 0, 0)).interp(Tween.EASE_IN, Tween.TRANS_QUAD),
			LerpProperty.new(paper, ^"global_position", 0.6, final_pos).interp(Tween.EASE_IN, Tween.TRANS_QUAD),
			LerpProperty.new(paper_2, ^"global_rotation", 0.4, Vector3(90, 0, 0)).interp(Tween.EASE_IN, Tween.TRANS_QUAD),
			LerpProperty.new(paper_2, ^"global_position", 0.6, final_pos_2).interp(Tween.EASE_IN, Tween.TRANS_QUAD)
		]),
	]).as_tween(user)
	await Task.delay(0.5)
	battle_node.focus_character(target_cog)
	await manager.barrier(projectile.finished, 1.0)
	paper.queue_free()
	paper_2.queue_free()
	AudioManager.play_sound(SFX_PAPER_HIT)
	
	# Apply the status effect
	var liability_waiver: StatEffectRegeneration = LIABILITY_WAIVER.duplicate(true)
	liability_waiver.target = target_cog
	liability_waiver.amount = floor(target_cog.stats.max_hp * 0.15)
	liability_waiver.rounds = -1
	manager.add_status_effect(liability_waiver)
	
	var liability_defense: StatEffectRegeneration = LIABILITY_WAIVER.duplicate(true)
	liability_defense.target = user
	liability_defense.amount = floor(user.stats.max_hp * 0.15)
	liability_defense.rounds = -1
	manager.add_status_effect(liability_defense)
	
	var dialogue_choice: String = response_lines[randi()%response_lines.size()]
	
	target_cog.speak(dialogue_choice)
	manager.battle_text.bind(user, "Curry Heal\nApplied!", BattleText.colors.green[0], BattleText.colors.green[1])
	manager.battle_text.bind(target_cog, "Curry Heal\nApplied!", BattleText.colors.green[0], BattleText.colors.green[1])
	
	await manager.sleep(4.5)
