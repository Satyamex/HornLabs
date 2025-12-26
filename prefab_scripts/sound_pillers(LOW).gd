extends AnimatableBody3D

@export var move_distance := -10.0
@export var move_speed := 6.0
var start_z: float
var target_z: float

func _ready():
	start_z = global_position.z
	target_z = start_z
	
func _physics_process(delta):
	var pos = global_position
	pos.z = move_toward(pos.z, target_z, move_speed * delta)
	global_position = pos
	if Input.is_action_just_pressed("low"):
		target_z = start_z + move_distance
	if Input.is_action_just_released("low"):
		target_z = start_z
	if Input.is_action_just_pressed("High"):
		target_z = start_z
		
