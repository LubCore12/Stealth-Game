extends CharacterBody2D

var player: CharacterBody2D
var direction_x: float
var is_moving := false

@onready var vision_shape = $VisionArea/Shape
@onready var turn_timer=$turn_Timer

@export_group("Movement")
@export var speed: float
@export var walk_speed: float
var t=randf()
var current_speed=walk_speed
var is_in_area=false

func setup(body: CharacterBody2D) -> void:
	player = body
	player.connect("full_awareness", start_moving)
	player.connect("stamina_use", func(val): if val>0:
		var dir_x = abs(player.global_position-global_position)
		if dir_x.x<200:
			is_moving=true
		)

func _physics_process(delta: float) -> void:
	t+=delta
	if player.collision_layer!=1:
		is_moving = false
		is_in_area=false
	if is_moving:
		pass
		#current_speed=speed
		#direction_x = (player.global_position-global_position).normalized().x
		#player.add_awareness(40)
	else:
		current_speed=walk_speed
		direction_x=sin(t*0.3)
	if direction_x > 0:
		var tween = create_tween()
		tween.tween_property(vision_shape, "rotation_degrees", 180, 0.2)
	else:
		var tween = create_tween()
		tween.tween_property(vision_shape, "rotation_degrees", 0, 0.2)
	velocity.x = direction_x * current_speed
	
	velocity.y += Global.GRAVITY_STRENGTH
	move_and_slide()

func turn():
	var tween = create_tween()
	tween.tween_property(vision_shape, "rotation_degrees", 0, 0.2)

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

func dead():
	if is_in_area:
		var tween=create_tween()
		tween.tween_property(self,"rotation_degrees",90,0.5)
		self_modulate=Color(1.0, 0.5, 0.5, 1.0)
		set_physics_process(false)
		$AttackArea.disconnect("body_entered", _on_attack_area_body_entered)
		$VisionArea.disconnect("body_exited", _on_vision_area_body_exited)
		$VisionArea.disconnect("body_entered", _on_vision_area_body_entered)
		player.disconnect("full_awareness", start_moving)
		$killArea.disconnect("body_entered", _on_kill_area_body_entered)
		$killArea.disconnect("body_exited", _on_kill_area_body_exited)

func _on_kill_area_body_entered(body: Node2D) -> void:
	if body==player:
		is_in_area=true

func _on_kill_area_body_exited(body: Node2D) -> void:
	if body==player:
		is_in_area=false
