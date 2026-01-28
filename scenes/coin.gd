extends Area2D

signal hit

var was_hit: bool = false

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not was_hit:
		was_hit = true
		hide()
		hit.emit()
