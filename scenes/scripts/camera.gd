extends Area2D

var player: CharacterBody2D

@onready var attack_timer = $Timers/AttackTimer
@onready var rotate_timer = $Timers/RotateTimer

@export_group("Camera stats")
@export var camera_damage: float

func setup(body: CharacterBody2D) -> void:
	player = body

func _on_body_entered(body: Node2D) -> void:
	if player and player == body:
		attack_timer.start()

func _on_body_exited(body: Node2D) -> void:
	if player and player == body:
		attack_timer.stop()

func _on_attack_timer_timeout() -> void:
	camera_damage+=0.1
	player.add_awareness(camera_damage)
	attack_timer.start()

var tween
func _on_rotate_timer_timeout() -> void:
	tween = create_tween()
	tween.tween_property(self, "rotation", 0.2, 1.0)
	tween.tween_interval(0.5)
	tween.tween_property(self, "rotation", -0.0, 1.0)
	tween.tween_interval(0.5)
	tween.tween_property(self, "rotation", -0.2, 1.0)
	tween.tween_interval(0.5)
	tween.tween_property(self, "rotation", 0.0, 1.0)
	tween.tween_interval(0.5)
	rotate_timer.wait_time=7
	rotate_timer.start()


func _on_control_panel_used() -> void:
	disconnect("body_entered",_on_body_entered)
	disconnect("body_exited",_on_body_exited)
	attack_timer.disconnect("timeout",_on_attack_timer_timeout)
	rotate_timer.disconnect("timeout",_on_rotate_timer_timeout)
	tween.kill()
	create_tween().tween_property(self, "rotation", 0, 2)
