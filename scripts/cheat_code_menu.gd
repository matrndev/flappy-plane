extends Control

func _on_line_edit_text_submitted(new_text: String) -> void:
	$LineEdit.clear()
	$LineEdit.placeholder_text = ""
	hide()
	
	match new_text:
		"DIE":
			$"../Player".dead = true
		"TSISTOOSLOW":
			$"..".scroll_speed += 20
		"IHAVEASEVERESKILLISSUE":
			TunableVariables.collisions_enabled = false
		"FILLMEUP":
			$"../Player".fuel_remaining += 2000
		"CLEARSTATS":
			SavedStats.reset_all()
		"":
			pass
		_:
			$LineEdit.placeholder_text = "learn to spell bro"
			show()

func _on_visibility_changed() -> void:
	if visible:
		$LineEdit.call_deferred("grab_focus")


func _on_line_edit_text_changed(new_text: String) -> void:
	# close if space because that resumes the game
	if new_text.contains(" "):
		$LineEdit.clear()
		hide()
		return
	
	# make all text caps because it looks better
	var caret: int = $LineEdit.caret_column
	$LineEdit.text = new_text.to_upper()
	$LineEdit.caret_column = caret
