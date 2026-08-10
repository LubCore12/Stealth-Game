extends Control

@onready var game_scene = "res://scenes/game.tscn"
@onready var play_button = $PlayButton

func _ready() -> void:
	play_button.connect("pressed", start_game)
	
func start_game() -> void:
	get_tree().change_scene_to_file(game_scene)
	
