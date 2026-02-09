extends Control

func _on_back_button_pressed() -> void:
	save_vars()
	
	TunableVariables.save_config()
	
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func save_vars() -> void:
	# save
	for slider in get_tree().get_nodes_in_group("sliders"):
		var key := name_to_key(slider.name)
		TunableVariables.set(key, slider.value)
	
	for check_box in get_tree().get_nodes_in_group("check_boxes"):
		var key := name_to_key(check_box.name)
		TunableVariables.set(key, check_box.button_pressed)

func _on_local_reset_button_pressed() -> void:
	$LocalResetDialog.show()

func _on_local_reset_dialog_confirmed() -> void:
	load_from_config()

func _ready() -> void:
	load_from_config()
	for slider in get_tree().get_nodes_in_group("sliders"):
		slider.value_changed.connect(_on_any_slider_value_changed.bind(slider))
	
	for line_edit in get_tree().get_nodes_in_group("line_edits"):
		line_edit.text_submitted.connect(_on_any_line_edit_value_changed.bind(line_edit))
	
	for check_box in get_tree().get_nodes_in_group("check_boxes"):
		check_box.toggled.connect(_on_any_check_box_toggled.bind(check_box))

func _on_any_check_box_toggled(toggled_on: bool, check_box: CheckBox) -> void:
	pass

func _on_any_slider_value_changed(value: float, slider: HSlider) -> void:
	# replicate slider to text
	var line_edit: LineEdit = slider.get_node("ValueLineEdit")
	line_edit.text = str(value)

func _on_any_line_edit_value_changed(new_text: String, line_edit: LineEdit) -> void:
	# replicate text to slider
	var slider: HSlider = line_edit.get_parent()
	slider.value = float(new_text)

func load_from_config() -> void:
	# set text to all boxes
	for slider in get_tree().get_nodes_in_group("sliders"):
		var key: String = name_to_key(slider.name)
		slider.value = float(TunableVariables.get(key))
		_on_any_slider_value_changed(slider.value, slider)
	
	for check_box in get_tree().get_nodes_in_group("check_boxes"):
		var key: String = name_to_key(check_box.name)
		check_box.button_pressed = TunableVariables.get(key)
		_on_any_check_box_toggled(check_box.button_pressed, check_box)

func name_to_key(node_name: String) -> String:
	node_name = node_name.replace("Slider", "")
	node_name = node_name.replace("CheckBox", "")
	# Convert CamelCase to snake_case
	var out: String = ""
	for i in node_name.length():
		var c: String = node_name[i]
		if c == c.to_upper() and i > 0:
			out += "_"
		out += c.to_lower()
	return out


func _on_tab_bar_tab_changed(tab: int) -> void:
	for container in get_tree().get_nodes_in_group("containers"):
		container.hide()
	match tab:
		0:
			$Panel/Panel/GameConfigContainer.show()
			$Panel/Panel/GameConfigContainer2.show()
		1:
			$Panel/Panel/PlayerConfigContainer.show()
		2:
			$Panel/Panel/PipeConfigContainer.show()
		3:
			$Panel/Panel/TorpedoConfigContainer.show()
	


func _on_file_dialog_file_selected(path: String) -> void:
	save_vars()
	TunableVariables.save_config(path)


func _on_save_button_pressed() -> void:
	$FileSaveDialog.show()


func _on_load_button_pressed() -> void:
	$FileLoadDialog.show()


func _on_file_load_dialog_file_selected(path: String) -> void:
	TunableVariables.load_config(path)
	load_from_config()


var currently_selected: int = 0

func _on_option_button_item_selected(index: int) -> void:
	currently_selected = index
	if index == 0:
		return
	$ResetDialog.show()

func _on_reset_dialog_canceled() -> void:
	$Panel/HBoxContainer/VBoxContainer/OptionButton.select(0)

func _on_reset_dialog_confirmed() -> void:
	match currently_selected:
		2: # easy
			TunableVariables.load_config("res://config_presets/easy.cfg")
		3: # medium
			TunableVariables.load_config("res://config_presets/medium.cfg")
		4: # hard
			TunableVariables.load_config("res://config_presets/hard.cfg")
		6: # money_maker
			TunableVariables.load_config("res://config_presets/money_maker.cfg")
	load_from_config()
