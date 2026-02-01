extends Control

var plane_sprite_path: String
var pipe_sprite_path: String


func _ready() -> void:
	refresh_texture()
	refresh_color_samples()


func refresh_texture() -> void:
	plane_sprite_path = "res://assets/plane_pack/planes/plane_%d/plane_%d_%s.png" % [TunableVariables.player_sprite_number, TunableVariables.player_sprite_number, TunableVariables.player_sprite_color]
	$Panel/HBoxContainer/TextureRect.texture = load(plane_sprite_path)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	TunableVariables.save_config()


func _on_switch_left_button_pressed() -> void:
	TunableVariables.player_sprite_number += 1
	if TunableVariables.player_sprite_number > 3:
		TunableVariables.player_sprite_number = 1
	refresh_texture()
	refresh_color_samples()


func _on_switch_right_button_pressed() -> void:
	TunableVariables.player_sprite_number -= 1
	if TunableVariables.player_sprite_number < 1:
		TunableVariables.player_sprite_number = 3
	refresh_texture()
	refresh_color_samples()


func refresh_color_samples() -> void:
	var rects = [
		$Panel/HBoxContainer2/ColorSampleRect1,
		$Panel/HBoxContainer2/ColorSampleRect2,
		$Panel/HBoxContainer2/ColorSampleRect3,
		$Panel/HBoxContainer2/ColorSampleRect4
	]
	
	var colors: Array = ["blue", "green", "red", "yellow"]
	
	var i = 0
	for color in colors:
		plane_sprite_path = "res://assets/plane_pack/planes/plane_%d/plane_%d_%s.png" % [TunableVariables.player_sprite_number, TunableVariables.player_sprite_number, color]
		rects[i].texture = load(plane_sprite_path)
		i += 1


func _on_color_sample_rect_button_1_pressed() -> void:
	TunableVariables.player_sprite_color = "blue"
	refresh_texture()


func _on_color_sample_rect_button_2_pressed() -> void:
	TunableVariables.player_sprite_color = "green"
	refresh_texture()


func _on_color_sample_rect_button_3_pressed() -> void:
	TunableVariables.player_sprite_color = "red"
	refresh_texture()


func _on_color_sample_rect_button_4_pressed() -> void:
	TunableVariables.player_sprite_color = "yellow"
	refresh_texture()
