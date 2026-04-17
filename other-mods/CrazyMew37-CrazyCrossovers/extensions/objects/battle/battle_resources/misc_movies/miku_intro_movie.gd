extends BattleStartMovie
class_name MikuIntroMovie

var directory: Node3D

func play() -> Tween:
	var miku: Cog = battle_node.cogs[1]
	var teto: Cog = battle_node.cogs[0]
	var neru: Cog = battle_node.cogs[2]
	# Get our dependencies
	directory = battle_node.get_parent()
	var player := Util.get_player()
	miku = directory.miku
	teto = directory.teto
	neru = directory.neru
	
	## MOVIE START
	movie = Sequence.new([
		Func.new(directory.first_cam.make_current),
		Func.new(player.set_global_position.bind(directory.first_pos.global_position)),
		Func.new(player.face_position.bind(directory.second_pos.global_position)),
		Func.new(player.set_animation.bind('walk')),
		Func.new(CameraTransition.from_current.bind(battle_node, directory.second_cam, 4.0)),
		LerpProperty.new(player, ^"global_position", 4.0, directory.second_pos.global_position),
		Func.new(player.set_animation.bind('neutral')),
		Func.new(miku.speak.bind("So, I was thinking about how we'll do our next show.")),
		Wait.new(3.5),
		Func.new(teto.speak.bind("Oooh, we should play one of my songs!")),
		Wait.new(2.5),
		Func.new(miku.speak.bind("No, we should sing something we can all accept. Any ideas, Neru?")),
		Wait.new(4.0),
		Func.new(player.set_animation.bind('think')),
		Func.new(neru.speak.bind("Hmm, well, I suppose we could-")),
		Wait.new(2.0),
		Func.new(neru.set_animation.bind('walk')),
		# to make it more ovbious she spotted the toon -cm37
		LerpProperty.new(neru, ^"rotation:y", 0.2, 0.0),
		Func.new(neru.set_animation.bind('neutral')),
		Func.new(neru.speak.bind("Er, what is THAT?")),
		Wait.new(1.5),
		Func.new(teto.set_animation.bind('walk')),
		Func.new(player.set_animation.bind('confused')),
		Func.new(AudioManager.play_sound.bind(load('res://audio/sfx/toon/avatar_emotion_confused.ogg'))),
		LerpProperty.new(teto, ^"rotation:y", 0.2, 0.0),
		Func.new(teto.set_animation.bind('neutral')),
		Func.new(miku.set_animation.bind('walk')),
		LerpProperty.new(miku, ^"rotation:y", 1.2, 0.0),
		Func.new(miku.set_animation.bind('neutral')),
		Func.new(miku.speak.bind("Well, looks like a special fan has run into us.")),
		Wait.new(3.25),
		Func.new(miku.set_animation.bind('effort')),
		Func.new(miku.animator.set_speed_scale.bind(2.0)),
		Func.new(miku.speak.bind("Let's give them a performance they'll never forget.")),
		Wait.new(3.0),
		Func.new(miku.animator.set_speed_scale.bind(1.0)),
		Func.new(battle_node.battle_cam.make_current),
		Func.new(start_music),
	]).as_tween(battle_node)

	return movie

func _skip() -> void:
	if movie and movie.is_running():
		movie.custom_step(1000000.0)
		movie.finished.emit()
		movie.kill()
