extends Control

var menu_path="res://scenes/menu.tscn"

func _on_resume_pressed() -> void:
	hide()
	get_tree().paused=false

func _on_exit_the_menu_pressed() -> void:
	Global.bombs=Global.max_bombs
	Global.completed_levels=[]
	Global.current_level_idx=0
	get_tree().paused=false
	get_tree().change_scene_to_file(menu_path)

func _on_quit_pressed() -> void:
	get_tree().quit()
