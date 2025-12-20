extends Node3D

@onready var interact_ray: RayCast3D = $"../cam/InteractRay"
@onready var horn_gun: Node3D = $horn_gun

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and interact_ray.is_colliding():
		var target: Node3D = interact_ray.get_collider()
		if target.is_in_group("pickable"):
			target.queue_free()
			horn_gun.visible = true
