extends BattleStartMovie
class_name MrKrabsIntroMovie

var directory: Node3D

func play() -> Tween:
	var mrkrabs: Cog = battle_node.cogs[0]
	var cog_dude: Cog = battle_node.cogs[1]
	# Get our dependencies
	directory = battle_node.get_parent()
	var player := Util.get_player()
	mrkrabs = directory.mrkrabs
	
	## MOVIE START
	movie = Sequence.new([
		Func.new(directory.first_cam.make_current),
		Func.new(player.set_global_position.bind(directory.start_pos.global_position)),
		Func.new(player.face_position.bind(directory.walk_in_pos.global_position)),
		Func.new(player.set_animation.bind('walk')),
		LerpProperty.new(player, ^"global_position", 3.0, directory.walk_in_pos.global_position),
		Func.new(player.set_animation.bind('neutral')),
		Func.new(mrkrabs.speak.bind("NOW WAIT JUST A SECOND THERE, BOYO!")),
		Func.new(mrkrabs.set_animation.bind('walk')),
		Func.new(player.set_animation.bind('slip-backward')),
		LerpProperty.new(mrkrabs, ^"rotation:y", 0.5, -1.06),
		Func.new(mrkrabs.set_animation.bind('neutral')),
		Func.new(AudioManager.play_sound.bind(load('res://audio/sfx/toon/MG_cannon_hit_dirt.ogg'))),
		Wait.new(0.75),
		Func.new(cog_dude.set_animation.bind('walk')),
		LerpProperty.new(cog_dude, ^"rotation:y", 0.75, -0.765),
		Func.new(cog_dude.set_animation.bind('neutral')),
		Wait.new(0.25),
		Func.new(mrkrabs.set_animation.bind('finger-wag')),
		Func.new(mrkrabs.speak.bind("Ye think ya can just leave without payin' first? Well, think again!")),
		Func.new(player.set_animation.bind('neutral')),
		Wait.new(4.0),
		Func.new(battle_node.battle_cam.make_current),
		Func.new(start_music),
	]).as_tween(battle_node)

	return movie

func _skip() -> void:
	if movie and movie.is_running():
		movie.custom_step(1000000.0)
		movie.finished.emit()
		movie.kill()
