extends ItemScript

func on_collect(_item: Item, _object: Node3D) -> void:
	stat_shuffle()
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	Util.s_floor_started.connect(_on_floor_started)

func _on_floor_started(_game_floor: GameFloor) -> void:
	await Task.delay(0.5)
	stat_shuffle()

func stat_shuffle() -> void:
	Util.get_player().stats.damage += (RNG.channel(RNG.ChannelSpinningTop).randi_range(-20,20) * 0.01)
	Util.get_player().stats.defense += (RNG.channel(RNG.ChannelSpinningTop).randi_range(-20,20) * 0.01)
	Util.get_player().stats.evasiveness += (RNG.channel(RNG.ChannelSpinningTop).randi_range(-20,20) * 0.01)
	Util.get_player().stats.luck += (RNG.channel(RNG.ChannelSpinningTop).randi_range(-20,20) * 0.01)
	Util.get_player().stats.speed += (RNG.channel(RNG.ChannelSpinningTop).randi_range(-20,20) * 0.01)
	AudioManager.play_sound(load("res://audio/sfx/battle/cogs/attacks/SA_head_grow_back_only.ogg"), 2.0)
	Util.get_player().boost_queue.queue_text("Stat Scramble!", Color.HOT_PINK)
