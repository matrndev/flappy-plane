extends Area2D


var hit_torpedo: bool = false


func _on_area_entered(area: Area2D) -> void:
	if area.name.begins_with("Torpedo") and not hit_torpedo:
		hit_torpedo = true
		set_deferred("monitorable", false)
		hide()
