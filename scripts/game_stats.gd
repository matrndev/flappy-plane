extends Control

var fuel_remaining: float = 0.0
var score: int = 0
var coins: int = 0
var fuel_warning: bool = false

@onready var fuel_bar: ProgressBar = $FuelBar
@onready var score_label: Label = $HBoxContainer/ScoreLabel
@onready var coin_label: Label = $HBoxContainer2/CoinLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fuel_bar.value = fuel_remaining
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
