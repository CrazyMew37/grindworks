extends Node3D

@onready var first_cam: Camera3D = %StompCam
@onready var second_cam: Camera3D = %MoleFocus
@onready var ash: Cog = %AshKetchum
@onready var pikachu: Cog = %Pikachu
@onready var cog_dude: Cog = %Cog
@onready var first_pos: Node3D = %WalkInPos
@onready var second_pos: Node3D = %StompPos

var manager: BattleManager = null

func _ready() -> void:
	pass
