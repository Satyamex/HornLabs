extends Node3D


func _on_button_pressed() -> void:
	$AnimationPlayer.play("change")
	$ColorRect.show()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://game_scenes/cutscene.tscn")
