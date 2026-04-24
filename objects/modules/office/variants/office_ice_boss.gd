extends Node3D

const BLIZZARD_SFX := preload("res://audio/sfx/battle/cogs/attacks/SA_brainstorm.ogg")
const START_MUSIC := preload('res://audio/music/solicitor/solicitorthemeintro.ogg')
const BOSS_MUSIC := preload('res://audio/music/solicitor/solicitortheme.ogg')
const VICTORY_MUSIC := preload('res://audio/music/solicitor/solicitorthemeend.ogg')

@onready var Puzzle := %PuzzleMemory
@onready var Solicitor := %Solicitor
@onready var Bookshelf := %bookshelfblocker
var facility_music: AudioStream

@onready var StartCamera := %StartCamera
@onready var EndCamera := %EndCamera

var BattleStarted := false
var BattleEnded := false
var player: Player

func _ready() -> void:
	Solicitor.VIRTUAL_COG_COLOR = Color('ccddfffe')
	
func start_body_entered(body: Node3D) -> void:
	if body is Player and not BattleStarted and not BattleEnded:
		player = body
		initialize()

func initialize() -> void:
	facility_music = AudioManager.music_player.stream
	player.state = Player.PlayerState.STOPPED
	player.set_animation('neutral')
	player.set_global_position(%FirstPos.global_position)
	player.face_position(Solicitor.global_position)
	intro_cutscene()

func intro_cutscene() -> void:
	Util.stuck_lock = true
	Util.get_player().game_timer_tick = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	%SkipButton.show()
	var movie_tween := create_tween()
	movie_tween.tween_callback(StartCamera.make_current)
	movie_tween.tween_interval(0.5)
	movie_tween.tween_callback(func():
		BattleStarted = true
		Solicitor.VIRTUAL_COG_COLOR = Color('ccddfffe')
		var env : Environment = Util.floor_manager.environment.environment.duplicate(true)
		env.background_energy_multiplier = 0.05
		env.fog_enabled = true
		env.fog_density = 0.036
		env.fog_light_color = Color('ddddff')
		Util.floor_manager.environment.environment = env
		Util.floor_manager.environment.environment.ambient_light_color = Color('bbbbff'))
	movie_tween.tween_callback(player.set_animation.bind('cringe'))
	movie_tween.tween_callback(AudioManager.play_sound.bind(player.toon.howl))
	movie_tween.tween_callback(AudioManager.play_sound.bind(BLIZZARD_SFX))
	movie_tween.tween_callback(AudioManager.set_music.bind(START_MUSIC))
	movie_tween.tween_interval(0.1)
	movie_tween.tween_callback(func():
		var env : Environment = Util.floor_manager.environment.environment.duplicate(true)
		env.background_energy_multiplier = 0.05
		env.fog_enabled = true
		env.fog_density = 0.052
		env.fog_light_color = Color('ddddff')
		Util.floor_manager.environment.environment = env
		Util.floor_manager.environment.environment.ambient_light_color = Color('bbbbff'))
	movie_tween.tween_interval(0.1)
	movie_tween.tween_callback(func():
		var env : Environment = Util.floor_manager.environment.environment.duplicate(true)
		env.background_energy_multiplier = 0.05
		env.fog_enabled = true
		env.fog_density = 0.068
		env.fog_light_color = Color('ddddff')
		Util.floor_manager.environment.environment = env
		Util.floor_manager.environment.environment.ambient_light_color = Color('bbbbff'))
	movie_tween.tween_interval(0.1)
	movie_tween.tween_callback(func():
		var env : Environment = Util.floor_manager.environment.environment.duplicate(true)
		env.background_energy_multiplier = 0.05
		env.fog_enabled = true
		env.fog_density = 0.084
		env.fog_light_color = Color('ddddff')
		Util.floor_manager.environment.environment = env
		Util.floor_manager.environment.environment.ambient_light_color = Color('bbbbff'))
	movie_tween.tween_interval(0.1)
	movie_tween.tween_callback(func():
		var env : Environment = Util.floor_manager.environment.environment.duplicate(true)
		env.background_energy_multiplier = 0.05
		env.fog_enabled = true
		env.fog_density = 0.1
		env.fog_light_color = Color('ddddff')
		Util.floor_manager.environment.environment = env
		Util.floor_manager.environment.environment.ambient_light_color = Color('bbbbff'))
	movie_tween.tween_interval(1.8)
	movie_tween.tween_callback(player.set_animation.bind('neutral'))
	movie_tween.tween_interval(0.8)
	# Solicitor rises from the ground
	movie_tween.tween_property(Solicitor, 'position:y', 0, 3.0)
	movie_tween.tween_interval(1.0)
	movie_tween.tween_callback(Solicitor.speak.bind("Who may this be? Is this a Toon, I see?"))
	movie_tween.tween_interval(3.0)
	movie_tween.tween_callback(Solicitor.speak.bind("Well, your progress will freeze right here! My maze shall bring you to tears!"))
	movie_tween.tween_interval(4.0)
	movie_tween.tween_callback(Solicitor.speak.bind("Watch out for my ghastly skulls. They'll turn your emotions dull!"))
	movie_tween.tween_interval(3.0)
	movie_tween.tween_callback(Solicitor.speak.bind("Good luck, you shmuck!"))
	movie_tween.tween_interval(1.0)
	movie_tween.tween_callback(Solicitor.set_animation.bind('walk'))
	movie_tween.tween_property(Solicitor, 'rotation_degrees:y', 0, 1.5)
	movie_tween.tween_property(Solicitor, 'position:z', 0, 3.25)
	movie_tween.tween_property(Bookshelf, 'position:y', 0, 0.25)
	movie_tween.tween_callback(Solicitor.set_animation.bind('neutral'))
	movie_tween.tween_callback(CameraTransition.from_current.bind(self, player.camera.camera, 1.0))
	movie_tween.tween_interval(1.0)
	movie_tween.tween_callback(player.camera.make_current)
	movie_tween.finished.connect(
	func():
		%SkipButton.hide()
		AudioManager.set_music(BOSS_MUSIC)
		Solicitor.set_global_position(%SolicitorEndPos.global_position)
		Solicitor.set_rotation_degrees(%SolicitorEndPos.rotation_degrees)
		
		movie_tween.kill()
		begin()
		Util.get_player().game_timer_tick = true
	)
	%SkipButton.pressed.connect(skip_intro.bind(movie_tween))

func skip_intro(tween: Tween) -> void:
	tween.custom_step(10000.0)

func begin() -> void:
	if player:
		player.state = Player.PlayerState.WALK
		player.camera.make_current()

func end_body_entered(body: Node3D) -> void:
	if body is Player and BattleStarted and not BattleEnded:
		player = body
		initialize_end()

func initialize_end() -> void:
	player.state = Player.PlayerState.STOPPED
	player.set_animation('neutral')
	player.set_global_position(%SecondPos.global_position)
	player.face_position(Solicitor.global_position)
	Puzzle.queue_free()
	end_cutscene()

func end_cutscene() -> void:
	Util.stuck_lock = false
	Util.get_player().game_timer_tick = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var movie_tween := create_tween()
	movie_tween.tween_callback(AudioManager.set_music.bind(VICTORY_MUSIC))
	movie_tween.tween_callback(CameraTransition.from_current.bind(self, EndCamera, 2.0))
	movie_tween.tween_interval(2.0)
	movie_tween.tween_callback(EndCamera.make_current)
	movie_tween.tween_callback(Solicitor.speak.bind("You somehow made it out?! Oh, you're gonna make me shout!"))
	movie_tween.tween_interval(3.0)
	movie_tween.tween_callback(Solicitor.speak.bind("My maze was supposed to end you, but it has failed me too!"))
	movie_tween.tween_interval(3.5)
	movie_tween.tween_callback(Solicitor.speak.bind("Grrrrr! I'm so angry, I could turn this place to dust! I'm so mad, it'll drive anyone to disgust!"))
	movie_tween.tween_callback(Solicitor.set_animation.bind('glower'))
	movie_tween.tween_interval(3.8)
	movie_tween.tween_callback(Solicitor.set_animation.bind('neutral'))
	movie_tween.tween_interval(1.7)
	movie_tween.tween_callback(Solicitor.speak.bind("I'm so furious, I could even comb-"))
	movie_tween.tween_interval(2.0)
	movie_tween.tween_callback(Solicitor.explode)
	movie_tween.tween_interval(2.1)
	movie_tween.tween_callback(func():
		BattleEnded = true
		var env : Environment = Util.floor_manager.environment.environment.duplicate(true)
		env.background_energy_multiplier = 0.05
		env.fog_enabled = true
		env.fog_density = 0.084
		env.fog_light_color = Color('ddddff')
		Util.floor_manager.environment.environment = env
		Util.floor_manager.environment.environment.ambient_light_color = Color('bbbbff'))
	movie_tween.tween_callback(AudioManager.play_sound.bind(BLIZZARD_SFX))
	movie_tween.tween_interval(0.1)
	movie_tween.tween_callback(func():
		var env : Environment = Util.floor_manager.environment.environment.duplicate(true)
		env.background_energy_multiplier = 0.05
		env.fog_enabled = true
		env.fog_density = 0.068
		env.fog_light_color = Color('ddddff')
		Util.floor_manager.environment.environment = env
		Util.floor_manager.environment.environment.ambient_light_color = Color('bbbbff'))
	movie_tween.tween_interval(0.1)
	movie_tween.tween_callback(func():
		var env : Environment = Util.floor_manager.environment.environment.duplicate(true)
		env.background_energy_multiplier = 0.05
		env.fog_enabled = true
		env.fog_density = 0.052
		env.fog_light_color = Color('ddddff')
		Util.floor_manager.environment.environment = env
		Util.floor_manager.environment.environment.ambient_light_color = Color('bbbbff'))
	movie_tween.tween_interval(0.1)
	movie_tween.tween_callback(func():
		var env : Environment = Util.floor_manager.environment.environment.duplicate(true)
		env.background_energy_multiplier = 0.05
		env.fog_enabled = true
		env.fog_density = 0.036
		env.fog_light_color = Color('ddddff')
		Util.floor_manager.environment.environment = env
		Util.floor_manager.environment.environment.ambient_light_color = Color('bbbbff'))
	movie_tween.tween_interval(0.1)
	movie_tween.tween_callback(func():
		var env : Environment = Util.floor_manager.environment.environment.duplicate(true)
		env.background_energy_multiplier = 0.05
		env.fog_enabled = true
		env.fog_density = 0.02
		env.fog_light_color = Color('ddddff')
		Util.floor_manager.environment.environment = env
		Util.floor_manager.environment.environment.ambient_light_color = Color('bbbbff'))
	movie_tween.tween_interval(0.75)
	movie_tween.tween_property(Bookshelf, 'position:y', -8, 0.25)
	movie_tween.tween_callback(CameraTransition.from_current.bind(self, player.camera.camera, 3.0))
	movie_tween.tween_interval(3.0)
	movie_tween.tween_callback(player.camera.make_current)
	movie_tween.finished.connect(
	func():
		Util.get_player().stats.charge_active_item(2)
		AudioManager.set_default_music(facility_music)
		AudioManager.stop_music()
		Globals.s_solicitor_boss_defeated.emit()
		ScoreTally.modify_score(ScoreTally.ChannelBosses, ScoreTally.BOSS_BONUS)
		movie_tween.kill()
		begin()
		Util.get_player().game_timer_tick = true
	)
