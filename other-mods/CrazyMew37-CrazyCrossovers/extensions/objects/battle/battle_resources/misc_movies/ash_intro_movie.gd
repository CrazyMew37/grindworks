extends BattleStartMovie
class_name AshIntroMovie

var directory: Node3D

func play() -> Tween:
	var ash: Cog = battle_node.cogs[1]
	var pikachu: Cog = battle_node.cogs[0]
	var cog_dude: Cog = battle_node.cogs[2]
	# Get our dependencies
	directory = battle_node.get_parent()
	var player := Util.get_player()
	ash = directory.ash
	pikachu = directory.pikachu
	
	## MOVIE START
	movie = Sequence.new([
		Func.new(directory.first_cam.make_current),
		Func.new(player.set_global_position.bind(directory.first_pos.global_position)),
		Func.new(player.face_position.bind(directory.second_pos.global_position)),
		Func.new(player.set_animation.bind('walk')),
		LerpProperty.new(player, ^"global_position", 2.5, directory.second_pos.global_position),
		Func.new(player.set_animation.bind('neutral')),
		Func.new(CameraTransition.from_current.bind(battle_node, directory.second_cam, 2.0)),
		Wait.new(2.0),
		Func.new(ash.set_animation.bind('walk')),
		LerpProperty.new(ash, ^"rotation:y", 1.5, 0.0),
		Func.new(ash.set_animation.bind('neutral')),
		Func.new(ash.speak.bind("AHA! Look, Pikachu!")),
		Func.new(pikachu.set_animation.bind('walk')),
		LerpProperty.new(pikachu, ^"rotation:y", 1.0, 0.0),
		Func.new(pikachu.set_animation.bind('neutral')),
		Func.new(cog_dude.set_animation.bind('walk')),
		LerpProperty.new(cog_dude, ^"rotation:y", 1.0, 0.0),
		Func.new(cog_dude.set_animation.bind('neutral')),
		Func.new(ash.speak.bind("Looks like we've found a brand new Pokemon to add to the team!")),
		Wait.new(4.25),
		Func.new(ash.speak.bind("Don't worry, Toon, I'm sure capturing you will be painless!")),
		Func.new(ash.set_animation.bind('effort')),
		Wait.new(5.75),
		Func.new(battle_node.battle_cam.make_current),
		Func.new(start_music),
	]).as_tween(battle_node)

	return movie

func _skip() -> void:
	if movie and movie.is_running():
		movie.custom_step(1000000.0)
		movie.finished.emit()
		movie.kill()
