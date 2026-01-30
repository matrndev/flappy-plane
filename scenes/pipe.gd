extends Area2D

signal hit
signal score

var hit_played: bool = false
var score_played: bool = false

var collisions_enabled: bool = TunableVariables.collisions_enabled

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
