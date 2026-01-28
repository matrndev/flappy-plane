extends StaticBody2D

signal entered
signal exited




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		entered.emit()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		exited.emit()
