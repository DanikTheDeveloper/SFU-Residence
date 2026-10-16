extends Node3D

func _ready() -> void:
	var ground := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(600, 1, 400)
	ground.mesh = box
	add_child(ground)
	ground.create_trimesh_collision()
	var camera := Camera3D.new()
	add_child(camera)
	camera.position = Vector3(60, 80, 100)
	camera.look_at(Vector3.ZERO)
	var sun := DirectionalLight3D.new()
	add_child(sun)
	sun.rotation_degrees = Vector3(-50, -30, 0)
