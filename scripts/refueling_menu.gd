extends Control

signal refueling_done

var speed: float = 600.0
var direction: int = 1
var started: bool = true
var fuel_picked: float = 0.0
var player_score: int
var player_dead: bool

@onready var bar: TextureRect = $Bar
@onready var cursor: ColorRect = $Cursor
@onready var fuel_picked_label: Label = $FuelPicked

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("keyboard_space") and started:
		started = false
		fuel_picked = (200 - cursor.position.y) / 2
		fuel_picked_label.text = "%.f" % fuel_picked
		$RefuelingDoneSound.play()
		if "%.f" % fuel_picked == "67":
			fuel_picked_label.add_theme_color_override("font_color", Color("#ff0000"))
			fuel_picked_label.add_theme_font_size_override("font_size", 67)
	elif event.is_action_pressed("keyboard_space") and not started:
		refueling_done.emit()

func _process(delta: float) -> void:
	var min_y: float = 0
	var max_y: float = 200 - cursor.size.y
	
	if player_dead:
		fuel_picked = 0
		refueling_done.emit()
		return
	
	if not started:
		return
	
	speed = randf_range(300.0, 700.0) + player_score * 10.0
	
	cursor.position.y += speed * direction * delta
	
	if cursor.position.y <= min_y:
		cursor.position.y = min_y
		direction = 1
	elif cursor.position.y >= max_y:
		cursor.position.y = max_y
		direction = -1
