extends Control



func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	

func load_file(path: String) -> void:
	var real_path = ProjectSettings.globalize_path(path)
	var file = FileAccess.open(real_path, FileAccess.READ)
	if file:
		$TextEdit.text = file.get_as_text()

func _on_license_button_1_pressed() -> void:
	load_file("res://assets/flappy-bird-assets-master/LICENSE")


func _on_license_button_2_pressed() -> void:
	load_file("res://assets/Flappy Bird Assets/readme.txt")


func _on_license_button_3_pressed() -> void:
	load_file("res://assets/plane_pack/sky_background/info.TXT")



func _on_license_button_4_pressed() -> void:
	load_file("res://assets/audio/cash_attrib.txt")
