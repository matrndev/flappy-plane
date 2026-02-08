extends Node

const STATS_FILE_PATH: String = "user://stats.cfg"

var coin_score: int
var best_score: int
var unlocked_player_sprite_numbers: Array[int]
var unlocked_player_sprite_colors: Array[String]

func _ready() -> void:
	load_stats()

func reset_all() -> void:
	coin_score = 0
	best_score = 0
	save_stats()

func load_stats() -> void:
	var stats_file: ConfigFile = ConfigFile.new()
	
	if stats_file.load(STATS_FILE_PATH) == OK:
		coin_score = stats_file.get_value("stats", "coin_score", coin_score)
		best_score = stats_file.get_value("stats", "best_score", best_score)
		
		unlocked_player_sprite_numbers = stats_file.get_value("unlocks", "unlocked_player_sprite_numbers", unlocked_player_sprite_numbers)
		unlocked_player_sprite_colors = stats_file.get_value("unlocks", "unlocked_player_sprite_colors", unlocked_player_sprite_colors)

func save_stats() -> void:
	var stats_file: ConfigFile = ConfigFile.new()
	stats_file.set_value("stats", "coin_score", coin_score)
	stats_file.set_value("stats", "best_score", best_score)
	
	stats_file.set_value("unlocks", "unlocked_player_sprite_numbers", unlocked_player_sprite_numbers)
	stats_file.set_value("unlocks", "unlocked_player_sprite_colors", unlocked_player_sprite_colors)
	
	
	stats_file.save(STATS_FILE_PATH)

func _notification(what: int) -> void:
	# save stats before exiting
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_stats()
		get_tree().quit()
