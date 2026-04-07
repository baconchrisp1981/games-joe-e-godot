extends Node

# Simple game manager - handles global game state

var game_paused = false
var current_level = "lab_level"
var player_health = 100
var score = 0

func _ready():
	print("Game Manager loaded")

func pause_game():
	game_paused = true
	get_tree().paused = true

func resume_game():
	game_paused = false
	get_tree().paused = false

func add_score(points):
	score += points

func reset_game():
	player_health = 100
	score = 0