extends BattleStartMovie
class_name FreddyIntroMovie

var directory: Node3D

func play() -> Tween:
	var freddy: Cog = battle_node.cogs[1]
	var bonnie: Cog = battle_node.cogs[0]
	var chica: Cog = battle_node.cogs[2]
	# Get our dependencies
	directory = battle_node.get_parent()
	var player := Util.get_player()
	freddy = directory.freddy
	bonnie = directory.bonnie
	chica = directory.chica
	
	## MOVIE START
	movie = Sequence.new([
		Func.new(directory.first_cam.make_current),
		Func.new(player.set_global_position.bind(directory.first_pos.global_position)),
		Func.new(player.face_position.bind(directory.second_pos.global_position)),
		Func.new(player.set_animation.bind('walk')),
		LerpProperty.new(player, ^"global_position", 4.0, directory.second_pos.global_position),
		Func.new(directory.second_cam.make_current),
		Func.new(player.set_animation.bind('neutral')),
		Wait.new(2.0),
		Func.new(player.face_position.bind(directory.look_left.global_position)),
		Func.new(player.set_animation.bind('walk')),
		Wait.new(0.2),
		Func.new(player.set_animation.bind('neutral')),
		Wait.new(0.5),
		Func.new(player.face_position.bind(directory.look_right.global_position)),
		Func.new(player.set_animation.bind('walk')),
		Wait.new(0.2),
		Func.new(player.set_animation.bind('neutral')),
		Wait.new(1.0),
		Func.new(AudioManager.play_sound.bind(load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/freddylaugh.ogg"))),
		Wait.new(1.0),
		Func.new(player.set_animation.bind('walk')),
		Func.new(player.face_position.bind(directory.third_pos.global_position)),
		LerpProperty.new(player, ^"global_position", 0.2, directory.third_pos.global_position),
		Func.new(directory.third_cam.make_current),
		Func.new(player.set_animation.bind('neutral')),
		Wait.new(3.0),
		Func.new(player.set_animation.bind('walk')),
		Func.new(player.face_position.bind(directory.second_pos.global_position)),
		LerpProperty.new(player, ^"global_position", 0.2, directory.second_pos.global_position),
		Func.new(directory.second_cam.make_current),
		Func.new(freddy.set_global_position.bind(directory.freddy_pos.global_position)),
		Func.new(freddy.face_position.bind(directory.second_pos.global_position)),
		Func.new(player.set_animation.bind('neutral')),
		Func.new(AudioManager.play_sound.bind(load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/freddylaugh.ogg"))),
		Wait.new(0.5),
		Func.new(player.set_animation.bind('slip-backward')),
		Func.new(AudioManager.play_sound.bind(player.toon.howl)),
		Func.new(player.toon.set_emotion.bind(Toon.Emotion.SURPRISE)),
		Wait.new(2.75),
		Func.new(player.set_animation.bind('walk')),
		Func.new(player.face_position.bind(directory.third_pos.global_position)),
		LerpProperty.new(player, ^"global_position", 0.2, directory.third_pos.global_position),
		Func.new(player.set_animation.bind('neutral')),
		Func.new(directory.third_cam.make_current),
		Func.new(bonnie.set_global_position.bind(directory.bonnie_pos.global_position)),
		Func.new(chica.set_global_position.bind(directory.chica_pos.global_position)),
		Func.new(bonnie.face_position.bind(directory.second_pos.global_position)),
		Func.new(chica.face_position.bind(directory.second_pos.global_position)),
		Func.new(AudioManager.play_sound.bind(load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/audio/sfx/bonniemoan.ogg"))),
		Wait.new(0.5),
		Func.new(player.set_animation.bind('confused')),
		Func.new(AudioManager.play_sound.bind(load('res://audio/sfx/toon/avatar_emotion_confused.ogg'))),
		Wait.new(3.0),
		Func.new(player.set_animation.bind('neutral')),
		Func.new(player.toon.set_emotion.bind(Toon.Emotion.NEUTRAL)),
		Wait.new(1.0),
		Func.new(battle_node.battle_cam.make_current),
		Func.new(start_music),
	]).as_tween(battle_node)

	return movie

func _skip() -> void:
	if movie and movie.is_running():
		movie.custom_step(1000000.0)
		movie.finished.emit()
		movie.kill()
