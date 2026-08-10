extends CharacterBody2D

var player: CharacterBody2D
var direction_x: float
var is_moving := false

@onready var vision_shape = $VisionArea/Shape

@export_group("Movement")
@export var speed: float

func setup(body: CharacterBody2D) -> void:
	player = body
	player.connect("full_awareness", start_moving)
	
func _physics_process(_delta: float) -> void:
	move()
	
func move() -> void:
	if is_moving:
		direction_x = (player.position - position).normalized().x
		if direction_x > 0:
			var tween = create_tween()
			tween.tween_property(vision_shape, "rotation_degrees", 180, 0.2)
		else:
			var tween = create_tween()
			tween.tween_property(vision_shape, "rotation_degrees", 0, 0.2)
		velocity.x = direction_x * speed
	
	velocity.y += Global.GRAVITY_STRENGTH
	move_and_slide()

func start_moving() -> void:
	is_moving = true

func _on_vision_area_body_entered(body: Node2D) -> void:
	if player == body:
		is_moving = true

func _on_vision_area_body_exited(body: Node2D) -> void:
	if player == body:
		await get_tree().create_timer(1.5).timeout
		is_moving = false

func _on_attack_area_body_entered(body: Node2D) -> void:
	if player == body:
		player.add_awareness(999)
