extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Panel/HSlider.value = TunableVariables.gravity


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_h_slider_value_changed(value: float) -> void:
	$Panel/HSlider/Label.text = str($Panel/HSlider.value)
	TunableVariables.gravity = value
	TunableVariables.save_config()


func _on_reset_button_pressed() -> void:
	TunableVariables.reset_all()
