extends Node3D

@onready var path := %Path3D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	for bucket in path.get_children():
		bucket.progress_ratio += .04 * delta
