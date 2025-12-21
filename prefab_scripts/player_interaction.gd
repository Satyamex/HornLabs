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

func horn_pulse(is_attract: bool) -> void:
	var origin: Vector3 = global_position
	for body in get_tree().get_nodes_in_group("sound_reactive"):
		if body is RigidBody3D:
			var rb: RigidBody3D = body
			var dir: Vector3 = rb.global_position - origin
			var distance: float = dir.length()
			if distance > horn_radius:
				continue
			dir = dir.normalized()
			# Attract = inward, Repel = outward
			if is_attract:
				dir = -dir
			var strength: float = horn_force * (1.0 - distance / horn_radius)
			rb.apply_impulse(dir * strength)
