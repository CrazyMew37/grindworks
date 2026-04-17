extends BattleStartMovie
class_name BowserIntroMovie

var directory: Node3D

func play() -> Tween:
	var bowser: Cog = battle_node.cogs[0]
	# Get our dependencies
	directory = battle_node.get_parent()
	var player := Util.get_player()
	bowser = directory.bowser
	
	## MOVIE START
	movie = Sequence.new([
		Func.new(directory.first_cam.make_current),
		Func.new(player.set_global_position.bind(directory.start_pos.global_position)),
		Func.new(player.face_position.bind(bowser.global_position)),
		Wait.new(1.5),
		Func.new(CameraTransition.from_current.bind(battle_node, directory.second_cam, 4.5)),
		Wait.new(4.5),
		Func.new(bowser.speak.bind("Aha! A pesky Toon! I needed something to practice my fire breath on!")),
		Wait.new(4.25),
		Func.new(bowser.speak.bind("What? You want to go to the elevator?")),
		Wait.new(2.75),
		Func.new(bowser.set_animation.bind('laugh')),
		Func.new(bowser.speak.bind("BWAHAHAHAHAH!!!")),
		Wait.new(3.3),
		Func.new(bowser.set_animation.bind('neutral')),
		Func.new(bowser.speak.bind("Well, too bad, punk! If you want to make it out of here, then you're gonna have to get through me first!")),
		Wait.new(5.5),
		Func.new(battle_node.battle_cam.make_current),
		Func.new(start_music),
	]).as_tween(battle_node)

	return movie

func _skip() -> void:
	if movie and movie.is_running():
		movie.custom_step(1000000.0)
		movie.finished.emit()
		movie.kill()
