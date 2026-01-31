extends CharacterBody2D

signal died

var jump_velocity: float = TunableVariables.jump_velocity
var max_jump_velocity: float = TunableVariables.max_jump_velocity
var gravity: float = TunableVariables.gravity
var rotation_down_step: int = TunableVariables.rotation_down_step
var rotation_down_limit: int = TunableVariables.rotation_down_limit
var rotation_up_step: int = TunableVariables.rotation_up_step
var rotation_up_limit: int = TunableVariables.rotation_up_limit
var trail_density: int = TunableVariables.trail_density
var fuel_consumption: float = TunableVariables.fuel_consumption

var dead: bool = false
var ready_to_start: bool = true
var gravity_enabled: bool = true
var fuel_remaining: float = 100.0

var sprite_path: String

func _ready() -> void:
	TunableVariables.load_config()
	sprite_path = "res://assets/plane_pack/planes/plane_%d/plane_%d_%s.png" % [TunableVariables.player_sprite_number, TunableVariables.player_sprite_number, TunableVariables.player_sprite_color]
	$Sprite2D.texture = load(sprite_path)

func _physics_process(delta: float) -> void:
	if ready_to_start:
		return
	
	if $"..".is_refueling or $"..".hold:
		return
	
	if dead and is_on_floor():
		$Sprite2D.self_modulate.a -= 0.02 # vanish
		return
	  	
	if not is_on_floor() and gravity_enabled:
		velocity.y += gravity * delta
		 
		if velocity.y > 0: # falling
			if rotation_degrees < rotation_down_limit:
				rotation_degrees += rotation_down_step
		else:
			if rotation_degrees > rotation_up_limit:
				rotation_degrees -= rotation_up_step
	
	if velocity.y > max_jump_velocity: # terminal velocity
		velocity.y = max_jump_velocity
	
	if Input.is_action_pressed("keyboard_c") and not dead: #and fuel_remaining > 20: # pause gravity
		gravity_enabled = false
		velocity.y = 7
		modulate = "#bf7aff"
		fuel_consumption = TunableVariables.fuel_consumption * 10
	else:
		gravity_enabled = true
		modulate = "#ffffff"
		fuel_consumption = TunableVariables.fuel_consumption
	
	if Input.is_action_just_pressed("keyboard_d") and not dead: # debug: die
		fuel_remaining = 0
	
	#if Input.is_action_just_pressed("keyboard_w") and not dead: # debug: extra fuel
		#fuel_remaining += 500
	
	if Input.is_action_just_pressed("keyboard_space") and not dead and not ready_to_start:
		velocity.y = jump_velocity
		fuel_remaining -= fuel_consumption * 50
		$WingSound.play()
	
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
	velocity.y = 0
	$Sprite2D.self_modulate.a = 1
	rotation_degrees = 0
	ready_to_start = false
	fuel_remaining = 100.0

func _on_game_start() -> void:
	reset()

func _on_ground_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		dead = true
		$DieSound.play()
		$"../GameStats".fuel_warning = false

func _on_game_refueling_finalized() -> void:
	# jump
	velocity.y = jump_velocity
	# make first jump free fuel_remaining -= fuel_consumption * 50
