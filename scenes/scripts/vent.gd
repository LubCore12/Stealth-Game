extends Node2D

var player
var is_in_area=false
signal vent_used(pos)

func _process(_delta: float) -> void:
	get_input()
	
func get_input() -> void:
	if Input.is_action_just_pressed("action") and is_in_area:
		vent_used.emit(global_position)

func setup(body):
	player = body

func _on_body_entered(body: Node2D) -> void:
	if body and body == player:
		is_in_area = true

func _on_body_exited(body: Node2D) -> void:
	if body and body == player:
		is_in_area = false
