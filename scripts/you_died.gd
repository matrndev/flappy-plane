extends Control

signal play_again

func _on_play_again_button_pressed() -> void:
	play_again.emit()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
