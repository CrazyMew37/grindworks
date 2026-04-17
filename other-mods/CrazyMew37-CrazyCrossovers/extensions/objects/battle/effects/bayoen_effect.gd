@tool
extends GPUParticles3D


func _ready() -> void:
	refresh_mesh()

func refresh_mesh() -> void:
	draw_pass_1 = generate_mesh()

func generate_mesh() -> Mesh:
	var tmpMesh := ArrayMesh.new()
	var vertices : PackedVector3Array = []
	var uvs : PackedVector2Array = []
	
	vertices.push_back(position)
	vertices.push_back(position + Vector3(1.0, 0.0, 0.0))
	vertices.push_back(position)
	vertices.push_back(position + Vector3(-1.0, 0.0, 0.0))
	vertices.push_back(position)
	vertices.push_back(position+Vector3(0.0, 1.0, 0.0))
	vertices.push_back(position)
	vertices.push_back(position+Vector3(0.0, -1.0, 0.0))
	vertices.push_back(position)
	vertices.push_back(position+Vector3(0.0, 0.0, 1.0))
	vertices.push_back(position)
	vertices.push_back(position+Vector3(0.0, 0.0, -1.0))
	
	uvs.push_back(Vector2(0, 0))
	uvs.push_back(Vector2(0, 1))
	uvs.push_back(Vector2(1, 1))
	uvs.push_back(Vector2(1, 0))
	uvs.push_back(Vector2(0, 0))
	uvs.push_back(Vector2(0, 1))
	uvs.push_back(Vector2(1, 1))
	uvs.push_back(Vector2(1, 0))
	uvs.push_back(Vector2(0, 0))
	uvs.push_back(Vector2(0, 1))
	uvs.push_back(Vector2(1, 1))
	uvs.push_back(Vector2(1, 0))
