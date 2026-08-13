extends Node2D

var player
var is_in_area = false

signal wardrobe_used

func _process(_delta: float) -> void:
	get_input()
	
func get_input() -> void:
	if Input.is_action_just_pressed("action") and is_in_area:
		wardrobe_used.emit()

func setup(body):
	player = body
	wardrobe_used.connect(player._on_wardrobe_used)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body and body == player:
		is_in_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body and body == player:
		is_in_area = false
