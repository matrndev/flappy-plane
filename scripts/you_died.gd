extends Control

signal play_again

func _on_play_again_button_pressed() -> void:
	play_again.emit()
