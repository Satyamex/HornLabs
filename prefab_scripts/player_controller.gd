extends CharacterBody3D

@onready var cam_anchor: Node3D = $cam_anchor
@onready var cam: Camera3D = $cam_anchor/cam

var cam_sens: float = 0.0025
var game_paused: bool = false
var jump_velocity: float
var move_speed: float = 7.0
var jump_speed: float = 7.0
var acceleration: float = 100.0
var deceleration: float = 10.0
var moving: bool = false


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


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		game_paused = !game_paused
<<<<<<< Updated upstream
=======

	if Input.is_action_just_pressed("interact"):
		try_pick_gun()

	if Input.is_action_just_pressed("drop"):
		drop_gun()


func try_pick_gun():
	if held_gun != null:
		return
	if interact_ray.is_colliding():
		var body = interact_ray.get_collider()
		if body is RigidBody3D:
			pick_gun(body)

func pick_gun(gun: RigidBody3D):
	held_gun = gun
	$AnimationPlayer.play("pickup")
	gun.freeze = true
	gun.linear_velocity = Vector3.ZERO
	gun.angular_velocity = Vector3.ZERO
	gun.reparent(gun_holder, true)
	gun.transform = Transform3D.IDENTITY

func drop_gun():
	if held_gun == null:
		return
	var gun = held_gun
	held_gun = null
	gun.reparent(get_tree().current_scene)
	gun.global_position = gun_holder.global_position
	gun.freeze = false
	gun.apply_impulse(-transform.basis.z * 2.5)
>>>>>>> Stashed changes
