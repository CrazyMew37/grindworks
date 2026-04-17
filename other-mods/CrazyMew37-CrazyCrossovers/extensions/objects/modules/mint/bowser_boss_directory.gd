extends Node3D

@onready var first_cam: Camera3D = %FirstCam
@onready var second_cam: Camera3D = %SecondCam
@onready var bowser: Cog = %Bowser
@onready var start_pos: Node3D = %StartPos

var manager: BattleManager = null
var reinforcement_count := 0

func _ready() -> void:
	pass
