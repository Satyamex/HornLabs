extends Node3D

@onready var interact_ray: RayCast3D = $"../cam/InteractRay"
@onready var gun_holder: Node3D = $"."
@export var horn_force := 20.0
@export var horn_radius := 6.0

func _process(delta: float) -> void:
	if interact_ray.is_colliding():
		var target := interact_ray.get_collider()
		if target is Node and target.is_in_group("pickable"):
			$Label.show()
		else:
			$Label.hide()
	else:
		$Label.hide()

	if Input.is_action_just_pressed("interact") and interact_ray.is_colliding():
		var target := interact_ray.get_collider()
		if target is Node and target.is_in_group("pickable"):
			target.queue_free()
			show()
			$Label.hide()
			$"../../AnimationPlayer".play("pickup")
