extends Node3D

@onready var first_cam: Camera3D = %FirstCam
@onready var second_cam: Camera3D = %SecondCam
@onready var monika: Cog = %Monika
@onready var sayori: Cog = %Sayori
@onready var yuri: Cog = %Yuri
@onready var natsuki: Cog = %Natsuki
@onready var first_pos: Node3D = %StartPos
@onready var second_pos: Node3D = %WalkInPos

var manager: BattleManager = null

func _ready() -> void:
	pass
