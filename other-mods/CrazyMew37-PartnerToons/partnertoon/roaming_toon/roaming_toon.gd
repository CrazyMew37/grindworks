extends Actor
class_name RoamingToon

const FOLLOW_DISTANCE := 10.0
const MAX_DISTANCE := 20.0
const SAFE_DISTANCE := 5.0
const NAV_RADIUS := 5.0
const WALK_SPD := 6.0
const GRAVITY := -9.8
const DIG_CHANCE := 2
const CHEST_CHANCE := 2
var TREASURE_POOL: ItemPool

## ANIM CONSTANTS
const TELEPORT_HOLE := preload('res://objects/misc/teleport_hole/teleport_hole.tscn')
# Direct references to treasure chest here cause a cyclical reference error :(
const SFX_TP := preload('res://audio/sfx/toon/AV_teleport.ogg')


enum DoodleState {
	STOPPED,
	TRANSITION,
	NAVIGATE,
	BATTLE,
	AWAIT,
}
@export var state := DoodleState.STOPPED:
	set(x):
		_state_change(state,x)
		state = x
enum DoodleMood {
	NEUTRAL,
}
@export var mood := DoodleMood.NEUTRAL

@export var doodle_actions : Array[ToonAttack]

@onready var nav : NavigationAgent3D = $NavAgent
@onready var nav_timer : Timer = $NavPauseTimer
@onready var head_node := $Head
@onready var toon : Toon = $Toon
@onready var hole_placement : Node3D = $Toon/HolePlacement
@onready var sfx_player : AudioStreamPlayer3D = $SFX

# Navigation values
var want_goal := true
var following_player := false
var nav_pause_range := Vector2(1.0,2.0)
var player : Player:
	get: return Util.get_player()
var prev_pos : Vector3

# Should be reused for any interruptible behavior
# Such as: digging, teleporting, etc.
var tween : Tween

func _init():
	# GameLoader Requirement:
	# - doodle_treasure.tres has a very large dependency chain.
	#   Since this script extends Node and has a class_name, the editor will try
	#   to load all dependencies of it. This causes a large lag spike if preloaded.
	GameLoader.queue_into(GameLoader.Phase.GAMEPLAY, self, {
		'TREASURE_POOL': 'res://objects/items/pools/doodle_treasure.tres'
	})

func _physics_process(delta : float) -> void:
	match state:
		DoodleState.NAVIGATE:
			_physics_process_nav(delta)
		DoodleState.AWAIT:
			_physics_process_await(delta)
		DoodleState.STOPPED:
			return
		DoodleState.BATTLE:
			return
		_:
			if not is_on_floor():
				velocity.y += GRAVITY * delta
			move_and_slide()
	
	
	$Label.set_text(
		"State: " + DoodleState.keys()[state as int] 
		+"\nWant goal: "+str(want_goal)
		+"\nMood: " + get_mood_string(mood).to_upper()
		+"\nFollowing: " + str(following_player)
	)

func _physics_process_nav(delta : float) -> void:
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if not want_goal:
		return
	
	# Test for player distance
	if get_player_dist() > MAX_DISTANCE:
		teleport_away(DoodleState.AWAIT)
		return
	
	# Try for a new position once per frame if not reachable
	if (not nav.is_target_reachable() and not following_player) or is_target_reached():
		following_player = get_player_dist() > FOLLOW_DISTANCE
		nav.target_position = get_goal_pos()
		return
	
	# Following behaviors
	if following_player:
		# Target pos has to be updated every frame if following player
		nav.target_position = get_goal_pos()
		# Teleport away if player is in un-navigable area
		if not nav.is_target_reachable() and player.is_on_floor() and get_player_dist() > SAFE_DISTANCE:
			teleport_away(DoodleState.AWAIT)
			want_goal = false
			return
	
	# NAVIGATE
	# Get the next path pos
	var next_pos := nav.get_next_path_position()
	
	# Face towards the position
	var dir := global_position.direction_to(next_pos)
	toon.rotation.y = lerp_angle(toon.rotation.y,atan2(dir.x,dir.z),.3)
	
	# Move towards position
	global_position = global_position.move_toward(next_pos,delta * WALK_SPD)
	
	# Ensure Doodle is walking while navigating
	if not get_animation() == 'run':
		set_animation('run')
	
	# Move and slide to collide with stuff and all that
	move_and_slide()
	
	# Ensure Doodle won't endlessly walk into wall
	# Compare on x/z axis only
	if prev_pos and not following_player:
		if Vector2(global_position.x,global_position.z).is_equal_approx(Vector2(prev_pos.x,prev_pos.z)):
			goal_reached()
	
	# Keep track of previous position
	prev_pos = global_position 

func _physics_process_await(_delta) -> void:
	if not player:
		return
	
	# Go to a random position near the player
	global_position = player.position
	global_position.x += RNG.channel(RNG.ChannelDoodleDig).randf_range(-NAV_RADIUS / 2.0, NAV_RADIUS / 2.0)
	global_position.z += RNG.channel(RNG.ChannelDoodleDig).randf_range(-NAV_RADIUS / 2.0, NAV_RADIUS / 2.0)
	
	# If you can walk to the player from here, it's (probably) a legal space.
	nav.target_position = player.global_position
	if nav.is_target_reachable():
		teleport_in(DoodleState.NAVIGATE)

func get_goal_pos() -> Vector3:
	if following_player:
		return player.global_position
	else:
		var new_pos := global_position
		new_pos.x += RNG.channel(RNG.ChannelDoodleDig).randf_range(-NAV_RADIUS, NAV_RADIUS)
		new_pos.z += RNG.channel(RNG.ChannelDoodleDig).randf_range(-NAV_RADIUS, NAV_RADIUS)
		return new_pos

func goal_reached() -> void:
	# Protect against navigator calling this at weird times
	if not state == DoodleState.NAVIGATE:
		return
	want_goal = false
	set_animation('neutral')
	nav_reset()
	following_player = false

func nav_reset() -> void:
	nav.target_position = get_goal_pos()
	reset_timer()

func reset_timer() -> void:
	nav_timer.wait_time = RNG.channel(RNG.ChannelDoodleDig).randf_range(nav_pause_range.x, nav_pause_range.y)
	nav_timer.start()

func nav_pause_finished() -> void:
	if state == DoodleState.NAVIGATE:
		want_goal = true

func get_player_dist() -> float:
	if not player:
		return 0.0
	else:
		return global_position.distance_to(player.global_position)

func is_target_reached() -> bool:
	return global_position.distance_to(nav.target_position) < nav.target_desired_distance

func set_goal_pos(pos: Vector3) -> void:
	nav.target_position = pos

func set_animation(anim: String) -> void:
	toon.set_animation(anim)

func get_mood_string(doodle_mood: DoodleMood) -> String:
	return str(DoodleMood.keys()[doodle_mood as int]).to_lower()

func get_animation() -> String:
	return toon.initial_anim

func face_position(pos: Vector3) -> void:
	var rot: Vector3 = toon.rotation
	toon.look_at(pos)
	rot.y = toon.rotation.y
	toon.rotation = rot
	toon.rotation_degrees.y -= 180.0

## Object reacts to battle starting
func battle_started(battle: BattleNode) -> void:
	if state == DoodleState.STOPPED:
		return
	
	# Teleport away, and then back in for battle
	teleport_away(DoodleState.STOPPED)
	tween.finished.connect(func(): 
		global_position = battle.get_partner_position(player.partners.find(self))
		face_position(battle.global_position)
		teleport_in(DoodleState.BATTLE)
		tween.finished.connect(
		func(): 
			s_battle_ready.emit()
			set_animation('neutral')
		)
	)
	
	battle.s_battle_ending.connect(battle_ending)
	battle.s_battle_end.connect(battle_ended)

func get_attack() -> ToonAttack:
	if not doodle_actions.is_empty():
		var action: ToonAttack = doodle_actions.pick_random()
		action = action.duplicate(true)
		action.user = self
		action.damage = (action.damage + (Util.floor_number + 1)) * (Util.floor_number + 1)
		var possible_targets: Array = BattleService.ongoing_battle.cogs
		
		# Oh no! No targets. guess we suck.
		if len(possible_targets) == 0:
			return
		
		var highest_level_cog = possible_targets[0]
		# Pick out the highest level Cog in our roster
		for i in range(1,possible_targets.size()):
			var current_cog = possible_targets[i]
			if highest_level_cog.level < current_cog.level:
				highest_level_cog = current_cog
	
		action.targets = [highest_level_cog]
		return action
	return null


func teleport_away(new_state := DoodleState.STOPPED) -> void:
	state = DoodleState.TRANSITION
	
	var hole : Node3D = load('res://objects/misc/teleport_hole/teleport_hole.tscn').instantiate()
	tween = create_tween()
	tween.tween_callback(toon.right_hand_bone.add_child.bind(hole))
	hole.position = Vector3(-0.2,1.0,0.25)
	hole.rotation_degrees.z = 90.0
	tween.tween_callback(set_animation.bind('teleport'))
	AudioManager.play_sound(load("res://audio/sfx/toon/AV_teleport.ogg"))
	tween.tween_interval(1.6)
	tween.tween_callback(hole.reparent.bind(self))
	tween.parallel().tween_property(hole,'scale',Vector3(0.4,0.4,0.4),0.05)
	tween.parallel().tween_property(hole,'position',Vector3(0,0.1,0.5),0.05)
	tween.parallel().tween_property(hole,'rotation',Vector3(0,0,0),0.05)
	tween.tween_interval(1.3333)
	toon.get_node('DropShadow').hide()
	hole.get_node('AnimationPlayer').play('shrink')
	tween.tween_interval(0.5)
	toon.hide()
	hole.queue_free()
	tween.finished.connect(func(): state = new_state)

func teleport_in(new_state := DoodleState.STOPPED) -> void:
	state = DoodleState.TRANSITION
	
	tween = create_tween()
	toon.legs.position.y -= 10.0
	var hole : Node3D = load('res://objects/misc/teleport_hole/teleport_hole.tscn').instantiate()
	tween.tween_callback(add_child.bind(hole))
	hole.position.y = 0.01
	hole.scale *= 0.4
	hole.get_node('AnimationPlayer').play('grow')
	tween.tween_interval(0.5)
	toon.show()
	toon.get_node('DropShadow').show()
	tween.tween_callback(set_animation.bind('jump'))
	tween.tween_callback(toon.anim_seek.bind(0.4, true))
	tween.parallel().set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(toon.legs,'position:y',-toon.body_node_zero,0.25)
	hole.get_node('AnimationPlayer').play('shrink')
	tween.tween_interval(0.9333)
	#hole.get_node('ClipPlane').unapply_from_mesh_instances(meshes)
	hole.queue_free()
	tween.finished.connect(func(): state = new_state)
	

func cancel_anim() -> void:
	if tween: tween.kill()

func battle_ending() -> void:
	set_animation('victory-dance')


func battle_ended() -> void:
	state = DoodleState.NAVIGATE

@warning_ignore("unused_parameter")
func _state_change(old_state: DoodleState, new_state: DoodleState) -> void:
	cancel_anim()
	
	# State-specific changes
	match new_state:
		DoodleState.NAVIGATE:
			want_goal = true
			following_player = true

func play_sfx(stream: AudioStream) -> void:
	sfx_player.set_stream(stream)
	sfx_player.play()
