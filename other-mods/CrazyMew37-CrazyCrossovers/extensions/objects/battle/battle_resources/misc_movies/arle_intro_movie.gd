extends BattleStartMovie
class_name ArleIntroMovie

var directory: Node3D

func play() -> Tween:
	var arle: Cog = battle_node.cogs[0]
	var carbuncle: Cog = battle_node.cogs[1]
	# Get our dependencies
	directory = battle_node.get_parent()
	var player := Util.get_player()
	arle = directory.arle
	carbuncle = directory.carbuncle
	
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
		Func.new(arle.set_animation.bind('walk')),
		LerpProperty.new(arle, ^"rotation:y", 1.5, 0.0),
		Func.new(arle.set_animation.bind('neutral')),
		Func.new(arle.speak.bind("Heh, looks like we've found something to mess with, Carby!")),
		Func.new(carbuncle.set_animation.bind('walk')),
		LerpProperty.new(carbuncle, ^"rotation:y", 1.5, 0.0),
		Func.new(carbuncle.set_animation.bind('neutral')),
		Wait.new(3.0),
		Func.new(battle_node.battle_cam.make_current),
		Func.new(start_music),
	]).as_tween(battle_node)

	return movie

func _skip() -> void:
	if movie and movie.is_running():
		movie.custom_step(1000000.0)
		movie.finished.emit()
		movie.kill()
