extends CharacterBody2D

var player: CharacterBody2D
var direction_x: float
var is_moving := false

@export_group("Movement")
@export var speed: float

func setup(body: CharacterBody2D) -> void:
	player = body
	
func _physics_process(_delta: float) -> void:
	if is_moving:
		direction_x = (player.position - position).normalized().x
		velocity.x = direction_x * speed
	
	velocity.y += Global.GRAVITY_STRENGTH
	move_and_slide()

func _on_vision_area_body_entered(body: Node2D) -> void:
	if player == body:
		is_moving = true

func _on_vision_area_body_exited(body: Node2D) -> void:
	if player == body:
		await get_tree().create_timer(1.5).timeout
		is_moving = false

func _on_attack_area_body_entered(body: Node2D) -> void:
	if player == body:
		player.discard_health(999)
