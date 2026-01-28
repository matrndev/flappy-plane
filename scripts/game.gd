extends Node

signal start
signal refueling_finalized

@export var pipe_scene: PackedScene
@export var coin_scene: PackedScene
@export var station_scene: PackedScene
@export var refueling_menu_scene: PackedScene
@export var death_message_scene: PackedScene
var pipes: Array
var coins: Array
var stations: Array
var screen_size: Vector2i
var ground_scroll_pos: int
var ground_height: int
const SCROLL_SPEED: float = 3
const TRAIL_LENGTH: int = 200
const PIPE_VARIABILITY: int = 150
var score: int = 0
var coin_score: int = 0
var scroll_speed = SCROLL_SPEED
const REFUELING_SPEED: float = 10.0
var is_refueling: bool = false
const GENERATE_STATION_ON_FUEL_LEVEL: float = 40.0
var hold: bool = false

# TODO:
# - parallax effect
# - menu screen
# - shop
# - you died screen
# DONE: - refueling stations

func _ready() -> void:
	screen_size = get_window().size
	ground_height = $Ground.get_node("TileMapLayer").tile_set.tile_size.y * 7 # ground is made of 7 tiles
	generate_pipe()
	hold = true
	start.emit() # temp

func _process(delta: float) -> void:
	#scroll_speed = lerp(2.0, SCROLL_SPEED, $Player.fuel_remaining / 100.0) # idk with this one mate
	if Input.is_action_pressed("keyboard_a"): # !debug
		scroll_speed = 1
	else:
		scroll_speed = 3
		pass

	if $Player.dead: # temp
		show_death_message(true)
	#else:
		#show_death_message(false)
	
	# hold in air when starting new game
	if hold:
		if Input.is_action_just_pressed("keyboard_space"):
			hold = false
		return
	
	if $Player.ready_to_start == true or $Player.dead == true and $Player.is_on_floor() == true:
		#if Input.is_action_just_pressed("keyboard_space"):
			#start.emit() # restart game
		return

	if $Player.dead: # this triggers only when dead because of fuel depletion
		$"GameStats".fuel_warning = false
		return
	
	# refueling
	if is_refueling:
		return

	# ground scrolling
	ground_scroll_pos += scroll_speed
	if ground_scroll_pos >= screen_size.x:
		ground_scroll_pos = 0
	$Ground.position.x = -ground_scroll_pos

	# pipe moving
	for pipe in pipes:
		pipe.position.x -= scroll_speed

	# coin moving
	for coin in coins:
		coin.position.x -= scroll_speed

	# station moving
	for station in stations:
		station.position.x -= scroll_speed

	# update gamestats
	$GameStats.score = score
	$GameStats.coins = coin_score

	# plane trail
	$PlaneTrail.add_point(Vector2($Player.position.x + 20, $Player.position.y - 20))
	for i: int in range($PlaneTrail.get_point_count()):
		var point_pos: Vector2 = $PlaneTrail.get_point_position(i)

		point_pos.x -= scroll_speed
		$PlaneTrail.set_point_position(i, point_pos)

		if (i > TRAIL_LENGTH):
			$PlaneTrail.remove_point(0)



func _on_pipe_timer_timeout() -> void:
	generate_pipe()
	# spawn station
	if $Player.fuel_remaining < GENERATE_STATION_ON_FUEL_LEVEL:
		generate_station()

func _on_coin_timer_timeout() -> void:
	if randf() < 0.67:
		generate_coin()

func generate_pipe() -> void:
	var pipe: Area2D = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + 50
	pipe.position.y = (screen_size.y - ground_height) / 2.0 + randi_range(-PIPE_VARIABILITY, PIPE_VARIABILITY)
	pipe.hit.connect(bird_hit)
	pipe.score.connect(bird_score)
	pipe.add_to_group("pipes")
	add_child(pipe)
	pipes.append(pipe)

func generate_coin() -> void:
	var coin: Area2D = coin_scene.instantiate()
	coin.position.x = screen_size.x + randi_range(1000, 1600)
	coin.position.y = (screen_size.y - ground_height) / 2.0 + randi_range(-PIPE_VARIABILITY, PIPE_VARIABILITY)
	coin.hit.connect(coin_hit)
	coin.add_to_group("coins")
	add_child(coin)
	coins.append(coin)

func generate_station() -> void:
	var station: StaticBody2D = station_scene.instantiate()
	station.position.x = screen_size.x + 400 + randi_range(-200, 100)
	station.position.y = 545
	station.entered.connect(entered_refueling)
	station.add_to_group("stations")
	station.z_index = 3
	add_child(station)
	stations.append(station)

func entered_refueling() -> void:
	is_refueling = true
	$PipeTimer.paused = true
	$CoinTimer.paused = true
	$GameStats.fuel_warning = false
	show_refueling_menu()

var refueling_menu: Control
func show_refueling_menu() -> void:
	refueling_menu = refueling_menu_scene.instantiate()
	refueling_menu.position.x = $Player.position.x
	refueling_menu.position.y = $Player.position.y - 80
	refueling_menu.z_index = 3
	refueling_menu.player_score = score
	refueling_menu.player_dead = $Player.dead
	refueling_menu.refueling_done.connect(refueling_done)
	add_child(refueling_menu)

func refueling_done() -> void:
	is_refueling = false
	if refueling_menu.fuel_picked + $Player.fuel_remaining > 100.0:
		$Player.fuel_remaining = 100.0
	else:
		$Player.fuel_remaining += refueling_menu.fuel_picked
	refueling_menu.queue_free()
	$PipeTimer.paused = false
	$CoinTimer.paused = false
	clear_stations()
	refueling_finalized.emit()


func coin_hit() -> void:
	coin_score += 1

func bird_score() -> void:
	score += 1

func clear_pipes() -> void:
	pipes.clear()
	for node in get_tree().get_nodes_in_group("pipes"):
		node.queue_free()

func clear_coins() -> void:
	coins.clear()
	for node in get_tree().get_nodes_in_group("coins"):
		node.queue_free()

func clear_stations() -> void:
	stations.clear()
	for node in get_tree().get_nodes_in_group("stations"):
		node.queue_free()

func bird_hit() -> void:
	$Player.dead = true

func _on_player_died() -> void:
	score = 0
	clear_coins()
	clear_pipes()
	clear_stations()
	show_death_message(false)
	$PlaneTrail.clear_points()
	hold = true

var death_message: Control
func show_death_message(display: bool) -> void:
	if display:
		if death_message: # dont show if already instantiated
			return
		death_message = death_message_scene.instantiate()
		death_message.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
		death_message.z_index = 2
		death_message.play_again.connect(start.emit)
		add_child(death_message)
	elif not display and death_message:
		remove_child(death_message)
		death_message.queue_free()
		death_message = null

func _on_ready() -> void:
	pass # Replace with function body.
