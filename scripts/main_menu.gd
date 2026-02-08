extends Control


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_tunables_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tunables_menu.tscn")

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits_menu.tscn")

func _on_skin_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/skin_menu.tscn")

func _ready() -> void:
	var bus: int = AudioServer.get_bus_index("Master")
	if AudioServer.is_bus_effect_enabled(bus, 0):
		$Panel/VBoxContainer/HellSoundsCheckbox.button_pressed = true

func _on_hell_sounds_checkbox_toggled(toggled_on: bool) -> void:
	var bus: int = AudioServer.get_bus_index("Master")
	if toggled_on:
		for i in AudioServer.get_bus_effect_count(bus):
			AudioServer.set_bus_effect_enabled(bus, i, true)
	else:
		for i in AudioServer.get_bus_effect_count(bus):
			AudioServer.set_bus_effect_enabled(bus, i, false)
		
