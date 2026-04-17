extends BattleStartMovie
class_name AnnouncerIntroMovie

var directory: Node3D

func play() -> Tween:
	var announcer: Cog = battle_node.cogs[1]
	var cog_dude: Cog = battle_node.cogs[0]
	var cog_dude2: Cog = battle_node.cogs[2]
	# Get our dependencies
	directory = battle_node.get_parent()
	var player := Util.get_player()
	announcer = directory.announcer
	cog_dude = directory.cog_dude
	cog_dude2 = directory.cog_dude2
	
	## MOVIE START (EASY FLOOR)
	if Util.on_easy_floor():
		movie = Sequence.new([
			Func.new(directory.first_cam.make_current),
			Func.new(player.set_global_position.bind(directory.start_pos.global_position)),
			Func.new(player.face_position.bind(directory.walk_in_pos.global_position)),
			Func.new(player.set_animation.bind('walk')),
			LerpProperty.new(player, ^"global_position", 3.0, directory.walk_in_pos.global_position),
			Func.new(player.set_animation.bind('neutral')),
			Func.new(CameraTransition.from_current.bind(battle_node, directory.second_cam, 4.0)),
			Wait.new(4.0),
			Func.new(announcer.set_animation.bind('walk')),
			LerpProperty.new(announcer, ^"rotation:y", 1.5, 0.0),
			Func.new(announcer.set_animation.bind('neutral')),
			Func.new(announcer.speak.bind("Looks like we finally have enough contestants to play.")),
			Wait.new(1.0),
			Func.new(cog_dude.set_animation.bind('walk')),
			LerpProperty.new(cog_dude, ^"rotation:y", 1.0, 0.0),
			Func.new(cog_dude.set_animation.bind('neutral')),
			Func.new(cog_dude2.set_animation.bind('walk')),
			LerpProperty.new(cog_dude2, ^"rotation:y", 1.0, 0.0),
			Func.new(cog_dude2.set_animation.bind('neutral')),
			Func.new(announcer.speak.bind("Why are we competing here,, you might ask?")),
			Wait.new(2.5),
			Func.new(announcer.speak.bind("Budget cuts.")),
			Wait.new(2.0),
			Func.new(announcer.speak.bind("Anyway, the rules of this contest are simple.")),
			Wait.new(2.75),
			Func.new(announcer.speak.bind("You must target a specific cog each round.")),
			Wait.new(2.75),
			Func.new(announcer.speak.bind("Failure to do so will cause your defenses to go down, and therefore make you up for elimation.")),
			Wait.new(5.5),
			Func.new(announcer.speak.bind("You can complete the contest by defeating me and the other cogs.")),
			Wait.new(4.0),
			Func.new(announcer.speak.bind("Are you ready? Then let's begin.")),
			Wait.new(2.0),
			Func.new(battle_node.battle_cam.make_current),
			Func.new(start_music),
		]).as_tween(battle_node)
	## MOVIE START (HARD FLOOR)
	else:
		movie = Sequence.new([
			Func.new(directory.first_cam.make_current),
			Func.new(player.set_global_position.bind(directory.start_pos.global_position)),
			Func.new(player.face_position.bind(directory.walk_in_pos.global_position)),
			Func.new(player.set_animation.bind('walk')),
			LerpProperty.new(player, ^"global_position", 3.0, directory.walk_in_pos.global_position),
			Func.new(player.set_animation.bind('neutral')),
			Func.new(CameraTransition.from_current.bind(battle_node, directory.second_cam, 4.0)),
			Wait.new(4.0),
			Func.new(announcer.set_animation.bind('walk')),
			LerpProperty.new(announcer, ^"rotation:y", 1.5, 0.0),
			Func.new(announcer.set_animation.bind('neutral')),
			Func.new(announcer.speak.bind("Looks like we finally have enough contestants to play.")),
			Wait.new(1.0),
			Func.new(cog_dude.set_animation.bind('walk')),
			LerpProperty.new(cog_dude, ^"rotation:y", 1.0, 0.0),
			Func.new(cog_dude.set_animation.bind('neutral')),
			Func.new(cog_dude2.set_animation.bind('walk')),
			LerpProperty.new(cog_dude2, ^"rotation:y", 1.0, 0.0),
			Func.new(cog_dude2.set_animation.bind('neutral')),
			Func.new(announcer.speak.bind("Why are we competing here, you might ask?")),
			Wait.new(2.5),
			Func.new(announcer.speak.bind("Budget cuts.")),
			Wait.new(2.0),
			Func.new(announcer.speak.bind("Anyway, the rules of this contest are simple.")),
			Wait.new(2.75),
			Func.new(announcer.speak.bind("You must target a specific cog each round.")),
			Wait.new(2.75),
			Func.new(announcer.speak.bind("You also must choose a specific gag every round.")),
			Wait.new(3.0),
			Func.new(announcer.speak.bind("Mind you that you don't have to do both. You may use the specific gag on something other than the specific cog.")),
			Wait.new(5.5),
			Func.new(announcer.speak.bind("Failure to do either task will cause your defenses to go down, and therefore make you up for elimation.")),
			Wait.new(5.5),
			Func.new(announcer.speak.bind("You can complete the contest by defeating me and the other cogs.")),
			Wait.new(4.0),
			Func.new(announcer.speak.bind("Are you ready? Then let's begin.")),
			Wait.new(2.0),
			Func.new(battle_node.battle_cam.make_current),
			Func.new(start_music),
		]).as_tween(battle_node)

	return movie

func _skip() -> void:
	if movie and movie.is_running():
		movie.custom_step(1000000.0)
		movie.finished.emit()
		movie.kill()
