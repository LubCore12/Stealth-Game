extends Node2D

@export var is_right: bool
var levels=[load("res://levels/level_1.tscn")]
var player 

func setup(body):
	player=body


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body==player:
		if is_right:
			Global.completed_levels.append(get_parent())
			Global.current_level_idx+=1
			var level=levels.pick_random()
			get_tree().call_deferred("change_scene_to_packed", level)
		else:
			Global.current_level_idx-=1
			var level=Global.completed_levels[Global.current_level_idx]
			get_tree().call_deferred("change_scene_to_packed", level)
