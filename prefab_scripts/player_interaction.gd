extends Node3D

@onready var interact_ray: RayCast3D = $"../cam/InteractRay"
@onready var gun_holder: Node3D = $"."
@export var horn_force := 20.0
@export var horn_radius := 6.0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and interact_ray.is_colliding():
		var target: Node3D = interact_ray.get_collider()
		if target.is_in_group("pickable"):
			target.queue_free()
			$".".show()
			$"../../AnimationPlayer".play("pickup")
