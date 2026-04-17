extends Node3D

@onready var first_cam: Camera3D = %StompCam
@onready var second_cam: Camera3D = %MoleFocus
@onready var arle: Cog = %ArleNadja
@onready var carbuncle: Cog = %Carbuncle
@onready var first_pos: Node3D = %WalkInPos
@onready var second_pos: Node3D = %StompPos

var manager: BattleManager = null

func _ready() -> void:
	pass
