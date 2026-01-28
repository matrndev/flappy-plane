extends Area2D

signal hit
signal score

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		hit.emit()

func _on_safe_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		score.emit()
