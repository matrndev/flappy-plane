extends Node

const CONFIG_FILE_PATH: String = "user://tunables.cfg"

# default base assignments

# game
var scroll_speed: float = 3.0
var refueling_speed: float = 10.0
var generate_station_on_fuel_level: float = 40.0
var trail_length: int = 200
var pipe_variability: int = 150
var pipe_spawn_rate: float = 2.4
var coin_spawn_rate: float = 5.0

# player
var jump_velocity: float = -400.0
var max_jump_velocity: float = 600.0
var gravity: float = 800.0
var rotation_down_step: int = 1
var rotation_down_limit: int = 50
var rotation_up_step: int = 6
var rotation_up_limit: int = -10
var trail_density: int = 10
var fuel_consumption: float = 0.05
var player_sprite_number: int = 1
var player_sprite_color: String = "blue"

# pipe
var collisions_enabled: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_config()
	save_config()

func reset_all() -> void:
	print("reset all")
	# default base assignments
	
	# game
	scroll_speed = 3.0
	refueling_speed = 10.0
	generate_station_on_fuel_level = 40.0
	trail_length = 200
	pipe_variability = 150
	pipe_spawn_rate = 2.4
	coin_spawn_rate = 5.0

	# player
	jump_velocity = -400.0
	max_jump_velocity = 600.0
	gravity = 800.0
	rotation_down_step = 1
	rotation_down_limit = 50
	rotation_up_step = 6
	rotation_up_limit = -10
	trail_density = 10
	fuel_consumption = 0.05
	player_sprite_number = 1
	player_sprite_color = "blue"

	# pipe
	collisions_enabled = true

	save_config()

func load_config() -> void:
	var config_file = ConfigFile.new()
	if config_file.load(CONFIG_FILE_PATH) == OK:
		# game
		scroll_speed = config_file.get_value("game", "scroll_speed", scroll_speed)
		refueling_speed = config_file.get_value("game", "refueling_speed", refueling_speed)
		generate_station_on_fuel_level = config_file.get_value("game", "generate_station_on_fuel_level", generate_station_on_fuel_level)
		trail_length = config_file.get_value("game", "trail_length", trail_length)
		pipe_variability = config_file.get_value("game", "pipe_variability", pipe_variability)
		pipe_spawn_rate = config_file.get_value("game", "pipe_spawn_rate", pipe_spawn_rate)
		coin_spawn_rate = config_file.get_value("game", "coin_spawn_rate", coin_spawn_rate)
		
		# player
		jump_velocity = config_file.get_value("player", "jump_velocity", jump_velocity)
		max_jump_velocity = config_file.get_value("player", "max_jump_velocity", max_jump_velocity)
		gravity = config_file.get_value("player", "gravity", gravity)
		rotation_down_step = config_file.get_value("player", "rotation_down_step", rotation_down_step)
		rotation_down_limit = config_file.get_value("player", "rotation_down_limit", rotation_down_limit)
		rotation_up_step = config_file.get_value("player", "rotation_up_step", rotation_up_step)
		rotation_up_limit = config_file.get_value("player", "rotation_up_limit", rotation_up_limit)
		trail_density = config_file.get_value("player", "trail_density", trail_density)
		fuel_consumption = config_file.get_value("player", "fuel_consumption", fuel_consumption)
		player_sprite_number = config_file.get_value("player", "player_sprite_number", player_sprite_number)
		player_sprite_color = config_file.get_value("player", "player_sprite_color", player_sprite_color)
		
		# pipe
		collisions_enabled = config_file.get_value("pipe", "collisions_enabled", collisions_enabled)
		

func save_config() -> void:
	var config_file: ConfigFile = ConfigFile.new()
	
	# game
	config_file.set_value("game", "scroll_speed", scroll_speed)
	config_file.set_value("game", "refueling_speed", refueling_speed)
	config_file.set_value("game", "generate_station_on_fuel_level", generate_station_on_fuel_level)
	config_file.set_value("game", "trail_length", trail_length)
	config_file.set_value("game", "pipe_variability", pipe_variability)
	config_file.set_value("game", "pipe_spawn_rate", pipe_spawn_rate)
	config_file.set_value("game", "coin_spawn_rate", coin_spawn_rate)
	
	# player
	config_file.set_value("player", "jump_velocity", jump_velocity)
	config_file.set_value("player", "max_jump_velocity", max_jump_velocity)
	config_file.set_value("player", "gravity", gravity)
	config_file.set_value("player", "rotation_down_step", rotation_down_step)
	config_file.set_value("player", "rotation_down_limit", rotation_down_limit)
	config_file.set_value("player", "rotation_up_step", rotation_up_step)
	config_file.set_value("player", "rotation_up_limit", rotation_up_limit)
	config_file.set_value("player", "trail_density", trail_density)
	config_file.set_value("player", "fuel_consumption", fuel_consumption)
	config_file.set_value("player", "player_sprite_number", player_sprite_number)
	config_file.set_value("player", "player_sprite_color", player_sprite_color)
	
	# pipe
	config_file.set_value("pipe", "collisions_enabled", collisions_enabled)
	
	
	
	config_file.save(CONFIG_FILE_PATH)
