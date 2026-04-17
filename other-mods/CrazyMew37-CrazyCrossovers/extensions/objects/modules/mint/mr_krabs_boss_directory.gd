extends Node3D

@onready var first_cam: Camera3D = %FirstCam
@onready var mrkrabs: Cog = %MrKrabs
@onready var cog_dude: Cog = %Cog
@onready var start_pos: Node3D = %StartPos
@onready var walk_in_pos: Node3D = %WalkInPos

var manager: BattleManager = null
var reinforcement_count := 0

func _ready() -> void:
	pass
