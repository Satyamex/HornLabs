extends CharacterBody3D

@onready var cam_anchor: Node3D = $cam_anchor
@onready var cam: Camera3D = $cam_anchor/cam
@onready var gun_holder: Node3D = $cam_anchor/GunHolder
@export var pickup_distance := 3.0
@export var pickup_speed := 20.0
@onready var ray: RayCast3D = $cam_anchor/cam/InteractRay2
@export var max_attract_distance := 12.0
@export var attract_speed := 15.0
@export var throw_force := 18.0
var pickup_blocked := false
@export var pickup_block_time := 2.0

var cam_sens: float = 0.0025
var game_paused: bool = false
var jump_velocity: float
var move_speed: float = 7.0
var jump_speed: float = 7.0
var acceleration: float = 100.0
var deceleration: float = 10.0
var moving: bool = false
var held_body: RigidBody3D = null

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if !game_paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			rotate_y(-event.relative.x * cam_sens)
			cam_anchor.rotate_x(-event.relative.y * cam_sens)
			cam_anchor.rotation.x = clamp(cam_anchor.rotation.x, deg_to_rad(-85), deg_to_rad(85))
	if game_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_velocity = jump_speed
		velocity.y = jump_velocity

	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		moving = true
		velocity.x = lerpf(velocity.x, direction.x * move_speed, acceleration * delta)
		velocity.z = lerpf(velocity.z, direction.z * move_speed, acceleration * delta)
	else:
		moving = false
		velocity.x = lerpf(velocity.x, 0.0, deceleration * delta)
		velocity.z = lerpf(velocity.z, 0.0, deceleration * delta)
	move_and_slide()
	
	if Input.is_action_pressed("horn"):
		if held_body:
			_move_held_object()
			if Input.is_action_just_pressed("throw"):
				_throw_object()
		else:
			_try_attract()
	else:
		if held_body:
			_release_object()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		game_paused = !game_paused

	if gun_holder.visible:
		if Input.is_action_just_pressed("low"):
			$LowPitch.play()
			$AnimationPlayer.play("low")
			$HighPitch.stop()
		if Input.is_action_just_pressed("High"):
			$HighPitch.play()
			$AnimationPlayer.play("high")
			$LowPitch.stop()
		if Input.is_action_just_released("High"):
			$HighPitch.stop()
			$AnimationPlayer.play("idle")
		if Input.is_action_just_released("low"):
			$LowPitch.stop()
			$AnimationPlayer.play("idle")
			
func _try_pickup():
	if ray.is_colliding():
		var body = ray.get_collider()
		if body is RigidBody3D:
			held_body = body
			held_body.gravity_scale = 0
			held_body.angular_velocity = Vector3.ZERO

func _move_held_object():
	var target_pos = cam.global_position \
		+ (-cam.global_transform.basis.z * pickup_distance)
	var dir = target_pos - held_body.global_position
	if dir.length() < 0.05:
		held_body.linear_velocity = Vector3.ZERO
	else:
		held_body.linear_velocity = dir * pickup_speed
	held_body.angular_velocity = Vector3.ZERO

func _release_object():
	held_body.gravity_scale = 1
	held_body.linear_velocity *= 0.2
	held_body.angular_velocity = Vector3.ZERO
	held_body = null

func _try_attract():
	if pickup_blocked:
		return
	var body = ray.get_collider()
	if body is not RigidBody3D:
		return
	var distance: float = body.global_position.distance_to(cam.global_position)
	if distance > max_attract_distance:
		return
	var target_pos = cam.global_position \
		+ (-cam.global_transform.basis.z * pickup_distance)
	var dir = target_pos - body.global_position
	body.gravity_scale = 0
	body.angular_velocity = Vector3.ZERO
	body.linear_velocity = dir.normalized() * attract_speed
	if dir.length() < 0.3:
		held_body = body

func _throw_object():
	var dir = -cam.global_transform.basis.z
	held_body.gravity_scale = 1
	held_body.linear_velocity = dir * throw_force
	held_body.angular_velocity = Vector3.ZERO
	held_body = null
	pickup_blocked = true
	await get_tree().create_timer(pickup_block_time).timeout
	pickup_blocked = false
