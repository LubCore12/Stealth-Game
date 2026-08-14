extends Node2D

var player
var is_in_area = false

func setup(body):
	player = body

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body and body == player:
		is_in_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body and body == player:
		is_in_area = false
