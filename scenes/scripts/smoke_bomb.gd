extends Node2D

var player

func setup(body):
	player=body

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body==player and Global.bombs<Global.max_bombs:
		Global.bombs+=1
		queue_free()
