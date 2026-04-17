extends Node3D

@onready var first_cam: Camera3D = %FirstCam
@onready var second_cam: Camera3D = %SecondCam
@onready var third_cam: Camera3D = %ThirdCam
@onready var freddy: Cog = %Freddy
@onready var bonnie: Cog = %Bonnie
@onready var chica: Cog = %Chica
@onready var first_pos: Node3D = %FirstPos
@onready var second_pos: Node3D = %SecondPos
@onready var look_left: Node3D = %LookLeft
@onready var look_right: Node3D = %LookRight
@onready var third_pos: Node3D = %ThirdPos
@onready var freddy_pos: Node3D = %FreddyPos
@onready var bonnie_pos: Node3D = %BonniePos
@onready var chica_pos: Node3D = %ChicaPos
@onready var battle_node: BattleNode = %BattleNode

var manager: BattleManager = null

func _ready() -> void:
	pass
