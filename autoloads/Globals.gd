extends Node

var form = "Furry"

# SPAWN ITEM LAYER
var in_alter_dimension

# LOADING - SAVING DATA
const filepath = "user://saved_data.data"

func _ready():
	load_data()

func load_data():
	var file = File.new()
	if file.file_exists(filepath):
		file.open(filepath, File.READ)
		highscore = file.get_var()
		file.close()

func save_data():
	var file = File.new()
	file.open(filepath, File.WRITE)
	file.store_var(highscore)
	file.close()

# SCREEN SHAKE
var screen_shake
func screen_shake(duration = 0.2, fraquency = 15, amplitude = 16, priority = 0):
	screen_shake.start(duration, fraquency, amplitude, priority)

# HIGHSCORES
var highscore = 0 setget new_highscore

func new_highscore(new_best):
	highscore = new_best
	save_data()