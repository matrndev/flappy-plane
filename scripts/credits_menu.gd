extends Control



func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	



func _on_license_button_1_pressed() -> void:
	var path = ProjectSettings.globalize_path("res://assets/flappy-bird-assets-master/LICENSE")
	OS.shell_open(path)
