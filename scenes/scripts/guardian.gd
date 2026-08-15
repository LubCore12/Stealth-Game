extends CharacterBody2D

var player: CharacterBody2D
var direction_x: float
var is_moving := false

@onready var vision_shape = $areas/VisionArea/Shape
@onready var vision_area = $areas/VisionArea
@onready var attack_area = $areas/AttackArea
@onready var danger_area = $areas/DangerArea
@onready var kill_area = $areas/KillArea
@onready var noise_area = $areas/NoiseArea
@onready var raycast = $areas/RayCast2D
@onready var areas = $areas

@export_group("Movement")
@export var speed: float
@export var walk_speed: float
var time = randf()
var current_speed = walk_speed
var is_in_area = false
var is_in_vision_area = false

signal player_trapped

func setup(body: CharacterBody2D) -> void:
	player = body
	player.connect("full_awareness", start_moving)
	player.connect("stamina_use", func(val): if val>0:
		var dir_x = abs(player.global_position - global_position)
		if dir_x.x < 200:
			is_moving = true
	)

func _physics_process(delta: float) -> void:
	time += delta
	if player.collision_layer != 1:
		is_moving = false
		is_in_area = false
	if is_moving:
		current_speed = speed
		direction_x = (player.global_position-global_position).normalized().x
		if is_in_vision_area:
			player.add_awareness(40*delta)
	else:
		current_speed = walk_speed
		direction_x = sin(time * 0.3)
		
	if direction_x > 0:
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(vision_shape, "rotation_degrees", 180, 0.2)
		tween.tween_property(raycast, "rotation_degrees", 270, 0.2)
	else:
		var tween = create_tween()
		tween.parallel()
		tween.tween_property(vision_shape, "rotation_degrees", 0, 0.2)
		tween.tween_property(raycast, "rotation_degrees", 90, 0.2)
		
	velocity.x = direction_x * current_speed
	velocity.y += Global.GRAVITY_STRENGTH
	move_and_slide()
	
func dead():
	if is_in_area:
		collision_layer=8
		collision_mask=8
		player.stamina_use.emit(100)
		var tween=create_tween()
		tween.tween_property(self, "rotation_degrees", 90, 0.5)
		self_modulate = Color(1.0, 0.5, 0.5, 1.0)
		set_physics_process(false)
		areas.queue_free()

func start_moving() -> void:
	if player.global_position.x-global_position.x<200:
		is_moving = true

func _on_vision_area_body_entered(body: Node2D) -> void:
	if player == body and not raycast.is_colliding():
		is_moving = true
		is_in_vision_area = true

func _on_vision_area_body_exited(body: Node2D) -> void:
	if player == body:
		await get_tree().create_timer(1.5).timeout
		is_moving = false

func _on_attack_area_body_entered(body: Node2D) -> void:
	if player == body:
		player.add_awareness(100)
		
func _on_danger_area_body_entered(body: Node2D) -> void:
	if body == player:
		is_in_area = true

func _on_danger_area_body_exited(body: Node2D) -> void:
	if body == player:
		is_in_area = false

func _on_noise_area_body_entered(body: Node2D) -> void:
	if body == player and player.is_running:
		player.add_awareness(100)

func _on_kill_area_body_entered(body: Node2D) -> void:
	if body == player:
		player_trapped.emit()

func _on_smoke_body_entered(body):
	if body==self:
		set_physics_process(false)
		player.add_awareness(-500)
		areas.scale=Vector2(0,0)
		is_moving=false
		await get_tree().create_timer(4,false).timeout
		set_physics_process(true)
		areas.scale=Vector2(1,1)
