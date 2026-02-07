extends Control

var fuel_remaining: float = 0.0
var score: int = 0
var coins: int = 0
var fuel_warning: bool = false
var best_score: int = 0
var health_remaining: float = 0.0

@onready var fuel_bar: ProgressBar = $FuelBar
@onready var health_bar: ProgressBar = $HealthBar
@onready var score_label: Label = $HBoxContainer/ScoreLabel
@onready var coin_label: Label = $HBoxContainer2/CoinLabel
@onready var best_score_label: Label = $HBoxContainer3/BestScoreLabel

func _ready() -> void:
	best_score = SavedStats.best_score

func _process(delta: float) -> void:
	if score > best_score:
		best_score = score
		SavedStats.best_score = best_score
		$HBoxContainer/ScoreLabel.modulate = Color("#ffca00")
	if score < best_score:
		$HBoxContainer/ScoreLabel.modulate = Color("#ffffff")
	fuel_bar.value = fuel_remaining
	health_bar.value = health_remaining
	best_score_label.text = str(best_score)
	score_label.text = str(score)
	coin_label.text = str(coins)


func _on_flash_timer_timeout() -> void:
	if fuel_remaining > 30.0 or not fuel_warning:
		fuel_bar.modulate = Color("#ffffff")
		return
	
	if fuel_bar.modulate == Color("#ffffff"):
		fuel_bar.modulate = Color("#ff0000")
	else:
		fuel_bar.modulate = Color("#ffffff")
