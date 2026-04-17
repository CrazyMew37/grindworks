extends Node3D

@onready var first_cam: Camera3D = %FirstCam
@onready var second_cam: Camera3D = %SecondCam
@onready var announcer: Cog = %Announcer
@onready var cog_dude: Cog = %Cog
@onready var cog_dude2: Cog = %Cog2
@onready var start_pos: Node3D = %StartPos
@onready var walk_in_pos: Node3D = %WalkInPos

var manager: BattleManager = null
var reinforcement_count := 0

func _ready() -> void:
	pass
