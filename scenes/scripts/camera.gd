extends Area2D

var player: CharacterBody2D

@export_group("Camera stats")
@export var camera_damage: float

func setup(body: CharacterBody2D) -> void:
	player = body

func _on_body_entered(body: Node2D) -> void:
	if player and player == body:
		$Timers/AttackTimer.start()
		
func _on_body_exited(body: Node2D) -> void:
	if player and player == body:
		$Timers/AttackTimer.stop()

func _on_attack_timer_timeout() -> void:
	player.discard_health(camera_damage)

func _on_rotate_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(self, "rotation", 0.2, 1.0)
	tween.tween_interval(0.5)
	tween.tween_property(self, "rotation", -0.0, 1.0)
	tween.tween_interval(0.5)	
	tween.tween_property(self, "rotation", -0.2, 1.0)
	tween.tween_interval(0.5)
	tween.tween_property(self, "rotation", 0.0, 1.0)
	tween.tween_interval(0.5)
