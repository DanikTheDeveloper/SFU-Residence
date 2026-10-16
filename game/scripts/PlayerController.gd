extends CharacterBody3D
const EYE_HEIGHT := 1.68 # Gameplay eye height in metres.
var pivot: Node3D
var camera: Camera3D
var sensitivity := 0.0025
var spawn := Vector3.ZERO
var enabled := true
var test_input := false

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
	pivot=Node3D.new()
	add_child(pivot)
	pivot.position.y=EYE_HEIGHT
	camera=Camera3D.new()
	camera.name="FirstPersonCamera"
	pivot.add_child(camera)
	camera.near=0.07
	camera.fov=72
	camera.far=1000
	camera.current=true
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and enabled and input_active():
		pivot.rotation.y-=event.relative.x*sensitivity
		pivot.rotation.x=clampf(pivot.rotation.x-event.relative.y*sensitivity,-1.45,1.45)
	if event.is_action_pressed("release_mouse"):
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton and event.pressed and event.button_index==MOUSE_BUTTON_LEFT and enabled:
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("respawn"): reset()

func reset(reason: String="manual") -> void:
	if test_input: print("PLAYER_RESET reason=",reason," position=",global_position)
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
	if global_position.y < -40: reset("fall")
