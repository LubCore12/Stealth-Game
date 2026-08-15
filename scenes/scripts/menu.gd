extends Control

@onready var level_0 = "res://levels/level_0.tscn"

func start_game() -> void:
	get_tree().change_scene_to_file(level_0)
	

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_support_button_pressed() -> void:
	OS.shell_open("https://youtu.be/dQw4w9WgXcQ?si=5TQWdGqfeL4Z7P3d")
