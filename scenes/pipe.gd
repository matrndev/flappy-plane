extends Area2D

signal hit
signal score

var hit_played: bool = false
var score_played: bool = false

var collisions_enabled: bool = TunableVariables.collisions_enabled

func _ready() -> void:
	change_style(TunableVariables.pipe_sprite_number, TunableVariables.pipe_sprite_color)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and collisions_enabled:
		if not hit_played:
			$HitSound.play()
			hit_played = true
		hit.emit()


func _on_safe_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if not score_played:
			$ScoreSound.play()
			score_played = true
		score.emit()


func change_style(new_style_type: int, new_style_color: String) -> bool:
	var changing_successful: bool = false
	var new_pipe_name: String = "PipeStyle%d%s" % [new_style_type, new_style_color]
	for child in $PipeStyles.get_children():
		if child.name == new_pipe_name and changing_successful == false:
			child.visible = true
			changing_successful = true
		else:
			child.visible = false
	return changing_successful
