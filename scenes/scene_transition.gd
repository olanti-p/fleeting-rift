extends CanvasLayer


func do_normal(new_scene: String) -> void:
	# TODO: animation
	get_tree().change_scene_to_file(new_scene)


func do_glitched(new_scene: String) -> void:
	# TODO: animation
	get_tree().change_scene_to_file(new_scene)


func do_shutdown(new_scene: String) -> void:
	# TODO: animation
	get_tree().change_scene_to_file(new_scene)
