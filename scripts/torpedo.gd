extends Area2D


signal hit

var was_hit: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not was_hit:
		$AudioStreamPlayer2D.play()
		was_hit = true
		if TunableVariables.deal_damage:
			hit.emit()
		hide()
