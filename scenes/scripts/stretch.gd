extends Area2D

var player: CharacterBody2D

func setup(body: CharacterBody2D) -> void:
	player = body

func _on_body_entered(body: Node2D) -> void:
	if player == body:
		player.add_awareness(50)

func _on_control_panel_panel_used() -> void:
	if is_connected("body_entered", _on_body_entered):
		disconnect("body_entered", _on_body_entered)
