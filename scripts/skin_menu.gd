extends Control

var plane_sprite_path: String
var pipe_sprite_path: String

var current_mode: int = 0
# 0: player
# 1: pipe

func _ready() -> void:
	refresh_texture()
	refresh_color_samples()


func refresh_texture() -> void:
	if current_mode == 0:
		plane_sprite_path = "res://assets/plane_pack/planes/plane_%d/plane_%d_%s.png" % [TunableVariables.player_sprite_number, TunableVariables.player_sprite_number, TunableVariables.player_sprite_color]
		$PlayerPanel/HBoxContainer/TextureRect.texture = load(plane_sprite_path)
	elif current_mode == 1:
		pass


func refresh_color_samples() -> void:
	var rects = [
		$PlayerPanel/HBoxContainer2/ColorSampleRect1,
		$PlayerPanel/HBoxContainer2/ColorSampleRect2,
		$PlayerPanel/HBoxContainer2/ColorSampleRect3,
		$PlayerPanel/HBoxContainer2/ColorSampleRect4
	]
	
	if current_mode == 0:
		var colors: Array = ["blue", "green", "red", "yellow"]
	
		var i = 0
		for color in colors:
			plane_sprite_path = "res://assets/plane_pack/planes/plane_%d/plane_%d_%s.png" % [TunableVariables.player_sprite_number, TunableVariables.player_sprite_number, color]
			rects[i].texture = load(plane_sprite_path)
			i += 1
	elif current_mode == 1:
		pass


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


func _on_tab_bar_tab_changed(tab: int) -> void:
	match tab:
		0:
			current_mode = 0
		1:
			current_mode = 1
