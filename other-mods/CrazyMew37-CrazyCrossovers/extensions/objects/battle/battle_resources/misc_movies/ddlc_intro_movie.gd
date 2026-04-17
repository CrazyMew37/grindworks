extends BattleStartMovie
class_name DDLCIntroMovie

var directory: Node3D

func play() -> Tween:
	var monika: Cog = battle_node.cogs[0]
	var sayori: Cog = battle_node.cogs[1]
	var yuri: Cog = battle_node.cogs[2]
	var natsuki: Cog = battle_node.cogs[3]
	# Get our dependencies
	directory = battle_node.get_parent()
	var player := Util.get_player()
	monika = directory.monika
	sayori = directory.sayori
	yuri = directory.yuri
	natsuki = directory.natsuki
	
	## MOVIE START
	movie = Sequence.new([
		Func.new(directory.first_cam.make_current),
		Func.new(player.set_global_position.bind(directory.first_pos.global_position)),
		Func.new(player.face_position.bind(directory.second_pos.global_position)),
		Func.new(player.set_animation.bind('walk')),
		LerpProperty.new(player, ^"global_position", 2.0, directory.second_pos.global_position),
		Func.new(player.set_animation.bind('neutral')),
		Func.new(CameraTransition.from_current.bind(battle_node, directory.second_cam, 3.0)),
		Wait.new(3.0),
		Func.new(player.set_animation.bind('think')),
		Wait.new(1.75),
		Func.new(monika.speak.bind("Okay, everyone!")),
		Func.new(monika.set_animation.bind('walk')),
		LerpProperty.new(monika, ^"rotation:y", 0.5, -0.332),
		Func.new(monika.set_animation.bind('neutral')),
		Wait.new(1.25),
		Func.new(player.set_animation.bind('neutral')),
		Func.new(monika.speak.bind("Looks like we have a new member for the club!")),
		Func.new(sayori.set_animation.bind('walk')),
		LerpProperty.new(sayori, ^"rotation:y", 0.5, -0.158),
		Func.new(sayori.set_animation.bind('neutral')),
		Func.new(yuri.set_animation.bind('walk')),
		LerpProperty.new(yuri, ^"rotation:y", 0.5, -0.363),
		Func.new(yuri.set_animation.bind('neutral')),
		Func.new(natsuki.set_animation.bind('walk')),
		LerpProperty.new(natsuki, ^"rotation:y", 0.5, -0.614),
		Func.new(natsuki.set_animation.bind('neutral')),
		Wait.new(1.75),
		Func.new(natsuki.speak.bind("Seriously? We found a Toon? Way to kill the atmosphere.")),
		Wait.new(3.5),
		Func.new(monika.speak.bind("Don't worry, everyone. I'm sure by the end of this, they'll know literature as well as we do.")),
		Func.new(monika.set_animation.bind('effort')),
		Wait.new(5.25),
		Func.new(natsuki.speak.bind("Ugh...")),
		Wait.new(0.5),
		Func.new(monika.set_animation.bind('neutral')),
		Wait.new(1.5),
		Func.new(battle_node.battle_cam.make_current),
		Func.new(start_music),
	]).as_tween(battle_node)

	return movie

func _skip() -> void:
	if movie and movie.is_running():
		movie.custom_step(1000000.0)
		movie.finished.emit()
		movie.kill()
