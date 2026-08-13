extends Node2D

@onready var sprite = $Sprite2D

var player
var is_in_area = false
var panel_off = preload("res://assets/command_panel_off.png")

signal panel_used

func _process(_delta: float) -> void:
	get_input()
		
func get_input() -> void:
	if Input.is_action_just_pressed("action") and is_in_area:
		emit_signal("panel_used")
		sprite.texture=panel_off

func setup(body):
	player = body

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body and body == player:
		is_in_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body and body == player:
		is_in_area = false
