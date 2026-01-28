extends CharacterBody2D

signal died

const JUMP_VELOCITY: float = -400.0
const MAX_JUMP_VELOCITY: float = 600.0
const GRAVITY: float = 800.0
const ROTATION_DOWN_STEP: int = 1
const ROTATION_DOWN_LIMIT: int = 50
const ROTATION_UP_STEP: int = 6
const ROTATION_UP_LIMIT: int = -10
const TRAIL_DENSITY: int = 10
const FUEL_CONSUMPTION: float = 0.05
var dead: bool = false
var ready_to_start: bool = true
var gravity: bool = true
var fuel_remaining: float = 100.0
var fuel_consumption = FUEL_CONSUMPTION

func _physics_process(delta: float) -> void:
	if ready_to_start:
		return
	
	if $"..".is_refueling or $"..".hold:
		return
	
	if dead and is_on_floor():
		$Sprite2D.self_modulate.a -= 0.01 # vanish
		return
	  	
	if not is_on_floor() and gravity:
		velocity.y += GRAVITY * delta
		 
		if velocity.y > 0: # falling
			if rotation_degrees < ROTATION_DOWN_LIMIT:
				rotation_degrees += ROTATION_DOWN_STEP
		else:
			if rotation_degrees > ROTATION_UP_LIMIT:
				rotation_degrees -= ROTATION_UP_STEP
	
	if velocity.y > MAX_JUMP_VELOCITY: # terminal velocity
		velocity.y = MAX_JUMP_VELOCITY

	if Input.is_action_just_pressed("keyboard_space") and not dead and not ready_to_start:
		velocity.y = JUMP_VELOCITY
		fuel_remaining -= FUEL_CONSUMPTION * 50
	
	if Input.is_action_pressed("keyboard_c") and not dead: #and fuel_remaining > 20: # pause gravity
		gravity = false
		velocity.y = 7
		modulate = "#bf7aff"
		fuel_consumption = FUEL_CONSUMPTION * 10
	else:
		gravity = true
		modulate = "#ffffff"
		fuel_consumption = FUEL_CONSUMPTION
	
	if Input.is_action_just_pressed("keyboard_d") and not dead: # debug: die
		fuel_remaining = 0
	
	if Input.is_action_just_pressed("keyboard_w") and not dead: # debug: extra fuel
		fuel_remaining += 500
	
	if not dead:
		fuel_remaining -= fuel_consumption
		if fuel_remaining <= 0:
			dead = true
			fuel_remaining = 0
		# update gamestats
		$"../GameStats".fuel_remaining = fuel_remaining
		$"../GameStats".fuel_warning = true
	
	move_and_slide()

func die() -> void:
	died.emit()
	
func reset() -> void:
	die()
	dead = false
	$"../GameStats".fuel_warning = false
	position.y = 200
	$Sprite2D.self_modulate.a = 1
	rotation_degrees = 0
	ready_to_start = false
	fuel_remaining = 100.0

func _on_game_start() -> void:
	reset()

func _on_ground_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		dead = true
		$"../GameStats".fuel_warning = false

func _on_game_refueling_finalized() -> void:
	# jump
	velocity.y = JUMP_VELOCITY
	# make first jump free fuel_remaining -= FUEL_CONSUMPTION * 50
