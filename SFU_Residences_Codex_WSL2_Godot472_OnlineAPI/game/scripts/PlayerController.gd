extends CharacterBody3D
const Geo = preload("res://scripts/Geometry.gd")
var pivot: Node3D
var arm: SpringArm3D
var camera: Camera3D
var model: Node3D
var sensitivity := 0.0025
var spawn := Vector3.ZERO
var enabled := true
var test_input := false
var step_time := 0.0
var legs: Array[MeshInstance3D] = []

func _ready() -> void:
	name="Player"
	collision_layer=2
	collision_mask=1
	floor_snap_length=0.45
	var capsule := CapsuleShape3D.new()
	capsule.radius=0.3
	capsule.height=1.8
	var collider := CollisionShape3D.new()
	collider.shape=capsule
	collider.position.y=0.9
	add_child(collider)
	model=Node3D.new()
	add_child(model)
	var red := Geo.material(Color("b34438"))
	var dark := Geo.material(Color("263540"))
	var skin := Geo.material(Color("c7a78b"))
	rounded_part(Vector3(0,1.16,0),0.25,0.67,red).scale.z=0.7
	rounded_part(Vector3(0,1.65,0),0.17,0.35,skin)
	rounded_part(Vector3(0,1.78,0.025),0.175,0.35,dark).scale.y=0.35
	Geo.box(model,Vector3(0,1.15,0.22),Vector3(0.36,0.43,0.18),dark)
	for side in [-1,1]:
		legs.append(rounded_part(Vector3(side*0.13,0.43,0),0.095,0.8,dark))
		rounded_part(Vector3(side*0.3,1.08,0),0.075,0.65,red)
		Geo.box(model,Vector3(side*0.13,0.08,-0.05),Vector3(0.2,0.15,0.32),dark)
	pivot=Node3D.new()
	add_child(pivot)
	pivot.position.y=1.45
	pivot.rotation.x=-0.16
	arm=SpringArm3D.new()
	pivot.add_child(arm)
	arm.spring_length=4.8
	arm.margin=0.22
	arm.collision_mask=1
	arm.add_excluded_object(get_rid())
	var camera_shape := SphereShape3D.new()
	camera_shape.radius=0.2
	arm.shape=camera_shape
	camera=Camera3D.new()
	arm.add_child(camera)
	camera.fov=72
	camera.far=1000
	camera.current=true
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func rounded_part(pos: Vector3, radius: float, height: float, mat: Material) -> MeshInstance3D:
	var node:=MeshInstance3D.new()
	var mesh:=CapsuleMesh.new()
	mesh.radius=radius
	mesh.height=height
	mesh.radial_segments=12
	mesh.rings=4
	node.mesh=mesh
	node.material_override=mat
	model.add_child(node)
	node.position=pos
	return node

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and enabled and input_active():
		pivot.rotation.y-=event.relative.x*sensitivity
		pivot.rotation.x=clampf(pivot.rotation.x-event.relative.y*sensitivity,-1.1,0.65)
	if event.is_action_pressed("release_mouse"):
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton and event.pressed and event.button_index==MOUSE_BUTTON_LEFT and enabled:
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("respawn"): reset()

func reset() -> void:
	global_position=spawn
	velocity=Vector3.ZERO

func input_active() -> bool:
	return Input.mouse_mode==Input.MOUSE_MODE_CAPTURED or (test_input and "--verify" in OS.get_cmdline_user_args())

func _physics_process(delta: float) -> void:
	if not enabled: return
	var axis := Input.get_vector("move_left","move_right","move_forward","move_back") if input_active() else Vector2.ZERO
	var direction := Basis(Vector3.UP,pivot.rotation.y)*Vector3(axis.x,0,axis.y)
	var speed := 8.0 if Input.is_action_pressed("sprint") else 4.5
	velocity.x=move_toward(velocity.x,direction.x*speed,25*delta)
	velocity.z=move_toward(velocity.z,direction.z*speed,25*delta)
	if not is_on_floor(): velocity.y-=24*delta
	elif Input.is_action_just_pressed("jump") and input_active(): velocity.y=7.0
	move_and_slide()
	if direction.length()>0.1:
		model.rotation.y=lerp_angle(model.rotation.y,atan2(-direction.x,-direction.z),delta*12)
		step_time+=delta*speed*2.1
		legs[0].rotation.x=sin(step_time)*0.45
		legs[1].rotation.x=-sin(step_time)*0.45
	else:
		for leg in legs: leg.rotation.x=0
	if global_position.y < -40: reset()
