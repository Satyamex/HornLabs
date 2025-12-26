extends Node3D

@onready var animation_player: AnimationPlayer = $Sketchfab_Scene9/AnimationPlayer
@onready var animation_player_1: AnimationPlayer = $Sketchfab_Scene12/AnimationPlayer1
@onready var gun_holder: Node3D = $cam_anchor/GunHolder
@onready var door_open: AudioStreamPlayer3D = $Sketchfab_Scene9/door_open
@onready var door_close: AudioStreamPlayer3D = $Sketchfab_Scene9/door_close

func _on_area_3d_body_entered(body: Node3D) -> void:
	animation_player.play("door open")
	door_open.play()
	door_close.stop()

func _on_area_3d_body_exited(body: Node3D) -> void:
	animation_player.play("door close")
	door_close.play()
	door_open.stop()

func _on_cutscene_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://game_scenes/stage.tscn")

func _on_end_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://game_scenes/stage2.tscn")

func _on_end_2_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://game_scenes/stage3.tscn")

func _on_end_3_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://game_scenes/stage4.tscn")

func _on_end_4_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://game_scenes/stage5.tscn")

func _on_area_3d_8_body_entered(body: Node3D) -> void:
	animation_player_1.play("door open")
	door_open.play()
	door_close.stop()

func _on_area_3d_8_body_exited(body: Node3D) -> void:
	animation_player_1.play("door close")
	door_close.play()
	door_open.stop()

func _on_end_5_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://game_scenes/stage6.tscn")

func _on_end_6_body_entered(body: Node3D) -> void:
	$ColorRect.show()
	animation_player.play("END")

func _on_death_body_entered(body: Node3D) -> void:
	if body == $player:
		get_tree().reload_current_scene()

func _on_disable_body_entered(body: Node3D) -> void:
	if body == $player:
		$disable.queue_free()
		
