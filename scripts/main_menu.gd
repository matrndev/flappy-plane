extends Control


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_tunables_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tunables_menu.tscn")

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits_menu.tscn")

func _on_skin_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/skin_menu.tscn")
