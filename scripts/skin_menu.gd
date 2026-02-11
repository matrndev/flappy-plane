extends Control

var plane_sprite_path: String
var pipe_sprite_path: String

var current_mode: int = 0
# 0: player
# 1: pipe

var currently_selected_texture_locked: bool = false

func _ready() -> void:
	$CoinDisplay/CoinLabel.text = str(SavedStats.coin_score)
	
	refresh_texture()
	refresh_color_samples()
	refresh_pipes()
	for pipe_button in get_tree().get_nodes_in_group("pipe_buttons"):
		pipe_button.pressed.connect(_on_any_pipe_button_pressed.bind(pipe_button))
	match TunableVariables.pipe_sprite_number: # load currently selected style category
		1:
			$PipePanel/OptionButton.select(0)
			_on_option_button_item_selected(0)
		2:
			$PipePanel/OptionButton.select(1)
			_on_option_button_item_selected(1)
		4:
			$PipePanel/OptionButton.select(2)
			_on_option_button_item_selected(2)
		5:
			$PipePanel/OptionButton.select(3)
			_on_option_button_item_selected(3)

func refresh_pipes() -> void:
	if TunableVariables.pipe_sprite_color == "":
		disable_all_pipes()
		$PipePanel/RandomizeCheckBox.button_pressed = true
		return
	
	for pipe_button in get_tree().get_nodes_in_group("pipe_buttons"):
		var pipe_color: String = pipe_button.name.replace("Pipe", "")
		var pipe_style: String = pipe_button.get_parent().name.replace("Pipes", "")
		
		if pipe_color == TunableVariables.pipe_sprite_color and int(pipe_style) == TunableVariables.pipe_sprite_number:
			pipe_button.disabled = true


func disable_all_pipes(disable: bool = true) -> void:
	for pipe_button in get_tree().get_nodes_in_group("pipe_buttons"):
		pipe_button.disabled = disable
		

func refresh_texture() -> void:
	# show locked overlay if sprite not unlocked
	if SavedStats.unlocked_player_sprite_numbers.has(TunableVariables.player_sprite_number) and SavedStats.unlocked_player_sprite_colors.has(TunableVariables.player_sprite_color):
		$PlayerPanel/HBoxContainer/TextureRect/LockedOverlay.hide()
		currently_selected_texture_locked = false
		load_unlock_button(false)
	else:
		$PlayerPanel/HBoxContainer/TextureRect/LockedOverlay.show()
		currently_selected_texture_locked = true
		load_unlock_button()
	
	plane_sprite_path = "res://assets/plane_pack/planes/plane_%d/plane_%d_%s.png" % [TunableVariables.player_sprite_number, TunableVariables.player_sprite_number, TunableVariables.player_sprite_color]
	$PlayerPanel/HBoxContainer/TextureRect.texture = load(plane_sprite_path)


func refresh_color_samples() -> void:
	var rects = [
		$PlayerPanel/HBoxContainer2/ColorSampleRect1,
		$PlayerPanel/HBoxContainer2/ColorSampleRect2,
		$PlayerPanel/HBoxContainer2/ColorSampleRect3,
		$PlayerPanel/HBoxContainer2/ColorSampleRect4
	]
	
	var overlays = [
		$PlayerPanel/HBoxContainer2/ColorSampleRect1/LockedOverlay,
		$PlayerPanel/HBoxContainer2/ColorSampleRect2/LockedOverlay,
		$PlayerPanel/HBoxContainer2/ColorSampleRect3/LockedOverlay,
		$PlayerPanel/HBoxContainer2/ColorSampleRect4/LockedOverlay
	]
	
	var colors: Array = ["blue", "green", "red", "yellow"]

	var i = 0
	
	for color in colors:
		plane_sprite_path = "res://assets/plane_pack/planes/plane_%d/plane_%d_%s.png" % [TunableVariables.player_sprite_number, TunableVariables.player_sprite_number, color]
		rects[i].texture = load(plane_sprite_path)
		
		if SavedStats.unlocked_player_sprite_numbers.has(TunableVariables.player_sprite_number) and SavedStats.unlocked_player_sprite_colors.has(color):
			overlays[i].hide()
		else:
			overlays[i].show()
		
		i += 1


func _on_back_button_pressed() -> void:
	if currently_selected_texture_locked:
		$TabBar.current_tab = 0
		$CantContinueDialog.show()
		return
	
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
	$PlayerPanel.hide()
	$PipePanel.hide()
	match tab:
		0:
			current_mode = 0
			$PlayerPanel.show()
		1:
			current_mode = 1
			$PipePanel.show()


func _on_any_pipe_button_pressed(button: Button) -> void:
	var selected_color: String = button.name.replace("Pipe", "")
	TunableVariables.pipe_sprite_color = selected_color
	
	var selected_style: String = button.get_parent().name.replace("Pipes", "")
	TunableVariables.pipe_sprite_number = int(selected_style)
	
	disable_all_pipes(false)
	button.disabled = true

func _on_option_button_item_selected(index: int) -> void:
	for node in get_tree().get_nodes_in_group("pipes"):
		node.hide()
	match index:
		0:
			$PipePanel/Pipes1.show()
			TunableVariables.pipe_sprite_number = 1
		1:
			$PipePanel/Pipes2.show()
			TunableVariables.pipe_sprite_number = 2
		2:
			$PipePanel/Pipes4.show()
			TunableVariables.pipe_sprite_number = 4
		3:
			$PipePanel/Pipes5.show()
			TunableVariables.pipe_sprite_number = 5
	refresh_pipes()


func _on_randomize_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		disable_all_pipes()
		TunableVariables.pipe_sprite_color = ""
	else:
		TunableVariables.pipe_sprite_color = "Green"
		disable_all_pipes(false)
		refresh_pipes()


func load_unlock_button(load: bool = true) -> void:
	if load:
		$PlayerPanel/UnlockButton.show()
	else:
		$PlayerPanel/UnlockButton.hide()


func _on_unlock_button_pressed() -> void:
	if SavedStats.coin_score - 10 < 0:
		$InsufficientCoinsDialog.show()
		return
	
	SavedStats.coin_score -= 10
	$CoinDisplay/CoinLabel.text = str(SavedStats.coin_score)
	SavedStats.unlocked_player_sprite_colors.append(TunableVariables.player_sprite_color)
	SavedStats.unlocked_player_sprite_numbers.append(TunableVariables.player_sprite_number)
	refresh_texture()
	refresh_color_samples()
