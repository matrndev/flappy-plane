extends Node

const CONFIG_FILE_PATH: String = "user://tunables.cfg"

# game
var scroll_speed: float
var refueling_speed: float
var generate_station_on_fuel_level: float
var trail_length: int
var pipe_variability: int
var pipe_spawn_rate: float
var coin_spawn_rate: float

# player
var jump_velocity: float
var max_jump_velocity: float
var gravity: float
var rotation_down_step: int
var rotation_down_limit: int
var rotation_up_step: int
var rotation_up_limit: int
var trail_density: int
var fuel_consumption: float
var player_sprite_number: int
var player_sprite_color: String

# pipe
var collisions_enabled: bool

func _ready() -> void:
	var config_file = ConfigFile.new()
	config_file.load(CONFIG_FILE_PATH)
	
	# if config doesn't exist, load default preset config
	if config_file.get_sections().is_empty():
		player_sprite_number = 2
		player_sprite_color = "green"
		reset_all()
	else:
		load_config()
		save_config()


func reset_all() -> void:
	load_config("res://config_presets/medium.cfg")
	save_config()

func load_config(path: String = "") -> void:
	if path == "":
		path = CONFIG_FILE_PATH
	
	var config_file = ConfigFile.new()
	
	if config_file.load(path) == OK:
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
		# sprite settings are controlled by separate menu and should not be overriden by loading custom config!
		# hence, load sprite settings only if loading user configuration in tunables.cfg
		if path == CONFIG_FILE_PATH: # only when loading from tunables.cfg
			player_sprite_number = config_file.get_value("player", "player_sprite_number", player_sprite_number)
			player_sprite_color = config_file.get_value("player", "player_sprite_color", player_sprite_color)
		
		# pipe
		collisions_enabled = config_file.get_value("pipe", "collisions_enabled", collisions_enabled)
		

func save_config(path: String = "") -> void:
	if path == "":
		path = CONFIG_FILE_PATH
	
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
	
	
	config_file.save(path)
