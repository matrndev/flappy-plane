extends Control


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_tunables_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tunables_menu.tscn")
