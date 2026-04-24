@tool
extends LawbotPuzzleGrid
class_name PuzzleSkullBounceIce

@export var skull_count := 100
@export var tick_rate := 2.5

class SkullObject:
	var position := Vector2i(0,0)
	var velocity := Vector2i(1,1)
	
	func move(grid: LawbotPuzzleGrid) -> Vector2:
		if position.x + velocity.x > grid.grid_width - 1 or position.x + velocity.x < 0:
			velocity.x = -velocity.x
			return move(grid)
		elif position.y + velocity.y > grid.grid_height - 1 or position.y + velocity.y < 0:
			velocity.y = -velocity.y
			return move(grid)
		position += velocity
		return position 
	
	func make_move(grid: PuzzleSkullBounceIce) -> void:
		grid.move_skull(self)

var skulls: Array[SkullObject] = []


## Overwrite this function to initialize your game
func initialize_game() -> void:
	for i in grid.size():
		for j in grid[i].size():
			var panel = grid[i][j]
			panel.panel_shape = PuzzlePanel.PanelShape.DOT
	
	# Create tick timer
	var timer := Timer.new()
	timer.wait_time = 1.0 / tick_rate
	add_child(timer)
	timer.start()
	
	# Initialize skulls
	for i in skull_count:
		var skull := create_skull()
		timer.timeout.connect(skull.make_move.bind(self))
		skulls.append(skull)

func move_skull(skull: SkullObject) -> void:
	var old_pos := skull.position
	var new_pos := skull.move(self)
	var new_panel: PuzzlePanel = grid[new_pos.x][new_pos.y]
	new_panel.panel_shape = PuzzlePanel.PanelShape.SKULL
	
	for s in skulls:
		if s.position == old_pos:
			return
	
	var old_panel: PuzzlePanel = grid[old_pos.x][old_pos.y]
	old_panel.panel_shape = PuzzlePanel.PanelShape.DOT
	

func create_skull() -> SkullObject:
	var skull := SkullObject.new()
	skull.position = Vector2i(RNG.channel(RNG.ChannelPuzzles).randi() % grid_width, RNG.channel(RNG.ChannelPuzzles).randi() % grid_height)
	skull.velocity = Vector2i([-1, 1].pick_random(), [-1, 1].pick_random())
	return skull


func player_stepped_on(panel: PuzzlePanel) -> void:
	if panel.panel_shape == PuzzlePanel.PanelShape.SKULL:
		lose_game_ice()

## Overwrite this function to change the colors of shapes
func panel_shape_changed(panel: PuzzlePanel, shape: PuzzlePanel.PanelShape) -> void:
	match shape:
		PuzzlePanel.PanelShape.SKULL: panel.set_color(Color.RED)
		PuzzlePanel.PanelShape.DOT: panel.set_color(Color.WHITE)
	
	if shape == PuzzlePanel.PanelShape.SKULL and panel in player_cells:
		lose_game_ice()

func get_game_text() -> String:
	return "The Solicitor's Maze"
	
func lose_game_ice() -> void:
	if Engine.is_editor_hint():
		return
	
	s_lose.emit()
	if lose_type == LoseType.BATTLE:
		if not lose_battle:
			push_error("ERR: NO BATTLE NODE SPECIFIED FOR PUZZLE")
			return
		lose_battle.show()
		lose_battle.player_entered(Util.get_player())
		queue_free()
	elif lose_type == LoseType.EXPLODE:
		explode_player_ice()

func explode_player_ice(iframe_time := 4.0) -> void:
	# Make Player slip backwards
	var player := Util.get_player()
	AudioManager.play_sound(player.toon.yelp)
	player.last_damage_source = "The Solicitor's Maze"
	player.quick_heal(Util.get_hazard_damage(explosion_damage))
	# Only do the animation if the player is alive
	if player.stats.hp > 0:
		player.state = Player.PlayerState.STOPPED
		player.set_animation('slip-backward')
		if iframe_time > 0.0:
			player.do_invincibility_frames(iframe_time)
	
	# Do Kaboom
	AudioManager.play_sound(load('res://audio/sfx/battle/cogs/ENC_cogfall_apart.ogg'))
	var kaboom := Sprite3D.new()
	kaboom.render_priority = 1
	kaboom.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	kaboom.texture = load('res://models/props/gags/tnt/kaboom.png')
	add_child(kaboom)
	kaboom.global_position = player.global_position
	kaboom.scale *= 0.25
	var kaboom_tween := create_tween()
	kaboom_tween.tween_property(kaboom,'pixel_size',.05,0.25)
	await kaboom_tween.finished
	kaboom_tween.kill()
	kaboom.queue_free()
	
	# Free player (only if they're alive)
	if player.stats.hp > 0:
		await player.animator.animation_finished
		player.state = Player.PlayerState.WALK
