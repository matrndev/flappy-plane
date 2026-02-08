extends Control

signal play_again

var revive_cost: int = 30

func _ready() -> void:
	$Control/ReviveButton.text = str(revive_cost)

func _on_play_again_button_pressed() -> void:
	play_again.emit()


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_revive_button_pressed() -> void:
	var player: CharacterBody2D = get_parent().get_node_or_null("Player")
	var game: Node2D = get_parent()
	
	if game.coin_score < revive_cost:
		$Control/InsufficientFundsLabel.show()
		$BuzzerPlayer.play()
		return
	
	game.coin_score -= revive_cost
	SavedStats.coin_score = game.coin_score
	
	game.clear_objects()
	player.dead = false
	player.health = TunableVariables.torpedo_damage
	game.get_node("GameStats").fuel_warning = false
	player.position.y = 200
	player.velocity.y = 0
	player.get_node("Sprite2D").self_modulate.a = 1
	player.rotation_degrees = 0
	player.ready_to_start = false
	player.fuel_remaining = 100.0
	game.hold = true
	queue_free()
