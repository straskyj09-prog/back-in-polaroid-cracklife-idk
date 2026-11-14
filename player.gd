extends CharacterBody3D

@export var speed := 6.0
@export var jump_velocity := 4.5
@export var mouse_sensitivity := 0.002

@onready var head: Node3D = $Head

@onready var hud = PolaroidHUD

#mouse movement (DO NOT TOUCH)
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event.is_action_pressed("take_photo"):
		print("SUCCESS: F key detected!")
		take_polaroid_snapshot()

func take_polaroid_snapshot() -> void:
	var room_objects = get_tree().get_nodes_in_group("time_sensitive")
	
	var snapshot = TimeManager.take_snapshot(self, room_objects)
	
	if hud:
		hud.add_polaroid_to_hud(snapshot, self, room_objects)
	else:
		print("Warning: PolaroidHUD singleton not found!")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
