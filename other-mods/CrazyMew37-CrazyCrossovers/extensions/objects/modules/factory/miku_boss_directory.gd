extends Node3D

@onready var first_cam: Camera3D = %FirstCam
@onready var second_cam: Camera3D = %SecondCam
@onready var miku: Cog = %Miku
@onready var teto: Cog = %Teto
@onready var neru: Cog = %Neru
@onready var first_pos: Node3D = %FirstPos
@onready var second_pos: Node3D = %SecondPos
@onready var battle_node: BattleNode = %BattleNode
@onready var elevator: Elevator = %SellbotElevator
@onready var elevator_cam: Camera3D = %ElevatorCam

var manager: BattleManager = null
var reinforcement_count := 0

func _ready() -> void:
	pass
