extends Node

signal start
signal refueling_finalized

@export var pipe_scene: PackedScene
@export var coin_scene: PackedScene
@export var station_scene: PackedScene
@export var refueling_menu_scene: PackedScene
@export var death_message_scene: PackedScene
@export var cheat_code_menu_scene: PackedScene
@export var torpedo_scene: PackedScene
var pipes: Array
var coins: Array
var stations: Array
var torpedoes: Array
var screen_size: Vector2i
var ground_scroll_pos: int
var ground_height: int
var trail_length: int = TunableVariables.trail_length
var pipe_variability: int = TunableVariables.pipe_variability
var torpedo_variability: int = TunableVariables.torpedo_variability
var score: int = 0
var coin_score: int = 0
var scroll_speed = TunableVariables.scroll_speed
var refueling_speed: float = TunableVariables.refueling_speed
var is_refueling: bool = false
var generate_station_on_fuel_level: float = TunableVariables.generate_station_on_fuel_level
var hold: bool = false

# TODO:
# DONE: - ship first version
# - more tunables (e.g. more granular fuel consumption, how easy the refueling station is)
# - shop (find a use for coins, maybe unlocking skins)
# - tutorial
# - enemy torpedoes
# - torpedoes remove your health instead of killing you instantly
# - torpedoes come in waves
# - more score = more torpedoes
# - refueling station better design
# - parallax effect
# - ally airplanes?
# - boss battles lol
# - more different minigames in the refueling station
# DONE: - change pipe skin / randomised pipe skin spawning
# - calculate falling rotation instead of it being hardcoded
# DONE: - change plane skin
# DONE: - menu screen
# DONE: - you died screen
# DONE: - refueling stations
# DONE: - tunables tabs
# DONE: - tunables finish (bug: rounding error)
# DONE: - cheat codes
# DONE: - saving/loading custom tunables settings
# DONE: - saving hs and coins into another singleton
# DONE: - presets for tunables based on difficulty

func _ready() -> void:
	coin_score = SavedStats.coin_score
	
	TunableVariables.load_config()
	$PipeTimer.wait_time = TunableVariables.pipe_spawn_rate
	$CoinTimer.wait_time = TunableVariables.coin_spawn_rate
	$TorpedoTimer.wait_time = TunableVariables.torpedo_spawn_rate
	
	# set trail color based on plane color
	match TunableVariables.player_sprite_color:
		"blue":
			$PlaneTrail.default_color = Color("6d97e7ff")
		"green":
			$PlaneTrail.default_color = Color("008a79ff")
			if TunableVariables.player_sprite_number == 1:
				$PlaneTrail.default_color = Color("c500b2ff")
		"red":
			$PlaneTrail.default_color = Color("dd0039ff")
		"yellow":
			$PlaneTrail.default_color = Color("b39703ff")
	
	screen_size = get_window().size
	ground_height = $Ground.get_node("TileMapLayer").tile_set.tile_size.y * 7 # ground is made of 7 tiles
	generate_pipe()
	hold = true
	start.emit() # temp
	#generate_torpedo()

func _process(delta: float) -> void:
	#scroll_speed = lerp(2.0, SCROLL_SPEED, $Player.fuel_remaining / 100.0) # idk with this one mate
	#if Input.is_action_pressed("keyboard_a"): # !debug
		#scroll_speed = 1
	#else:
		#scroll_speed = TunableVariables.scroll_speed
		##scroll_speed = 3
		#pass
	
	if Input.is_action_just_pressed("keyboard_t"):
		$CheatCodeMenu.show()
		hold = true
	
	if Input.is_action_just_pressed("keyboard_x"):
		hold = !hold
	
	if $Player.dead:
		show_death_message(true)
	
	# update gamestats
	$GameStats.score = score
	$GameStats.coins = coin_score
	
	# hold in air when starting new game
	if hold:
		$GamePausedLabel.show()
		if Input.is_action_just_pressed("keyboard_space"):
			hold = false
		return
	else:
		$GamePausedLabel.hide()
	
	if $Player.ready_to_start == true or $Player.dead == true and $Player.is_on_floor() == true:
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
	
	for torpedo in torpedoes:
		torpedo.position.x -= scroll_speed

	# plane trail
	$PlaneTrail.add_point(Vector2($Player.position.x + 20, $Player.position.y - 20))
	for i: int in range($PlaneTrail.get_point_count()):
		var point_pos: Vector2 = $PlaneTrail.get_point_position(i)

		point_pos.x -= scroll_speed
		$PlaneTrail.set_point_position(i, point_pos)

		if (i > trail_length):
			$PlaneTrail.remove_point(0)

func _on_torpedo_timer_timeout() -> void:
	if hold or is_refueling:
		return
	if score < 0: # torpedoes don't spawn until certain score reached TODO: TunableVariables
		return
	generate_torpedo()

func _on_pipe_timer_timeout() -> void:
	if hold or is_refueling:
		return
	generate_pipe()
	# spawn station
	if $Player.fuel_remaining < generate_station_on_fuel_level:
		generate_station()

func _on_coin_timer_timeout() -> void:
	if hold or is_refueling:
		return
	if randf() < 0.67:
		generate_coin()

func generate_pipe() -> void:
	var pipe: Area2D = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + 50
	pipe.position.y = (screen_size.y - ground_height) / 2.0 + randi_range(-pipe_variability, pipe_variability)
	pipe.hit.connect(bird_hit)
	pipe.score.connect(bird_score)
	pipe.add_to_group("pipes")
	add_child(pipe)
	pipes.append(pipe)

func generate_torpedo() -> void:
	var torpedo: Area2D = torpedo_scene.instantiate()
	torpedo.position.x = screen_size.x + 50
	torpedo.position.y = (screen_size.y - ground_height) / 2.0 + randi_range(-torpedo_variability, torpedo_variability)
	torpedo.hit.connect(torpedo_hit)
	torpedo.hit.connect($Player.hit_animation)
	torpedo.add_to_group("torpedoes")
	add_child(torpedo)
	torpedoes.append(torpedo)

func generate_coin() -> void:
	var coin: Area2D = coin_scene.instantiate()
	coin.position.x = screen_size.x + randi_range(1000, 1600)
	coin.position.y = (screen_size.y - ground_height) / 2.0 + randi_range(-pipe_variability, pipe_variability)
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

func torpedo_hit() -> void:
	$Player.health -= 25

func coin_hit() -> void:
	coin_score += 1
	SavedStats.coin_score = coin_score

func bird_score() -> void:
	score += 1

func clear_torpedoes() -> void:
	torpedoes.clear()
	for node in get_tree().get_nodes_in_group("torpedoes"):
		node.queue_free()

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


func _on_player_died() -> void:
	# reset game
	score = 0
	clear_coins()
	clear_pipes()
	clear_stations()
	clear_torpedoes()
	show_death_message(false)
	$PlaneTrail.clear_points()
	hold = true
