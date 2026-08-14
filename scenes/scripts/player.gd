extends CharacterBody2D

@onready var awareness_timer=$Timers/AwarenessTimer
@onready var stamina_timer=$Timers/StaminaTimer

var direction_x: float
var current_stamina: float
var current_awareness: float
var current_speed: float
var stamina_recovery := false
var is_running := false
var awareness_recovery := false

@export_group("Movement")
@export var speed: float
@export var jump_time_max: float
@export var jump_strength: float
@export var max_stamina: float
@export var stamina_speed: float
@export var stamina_usage: float
@export var jump_stamina_usage: float
@export var stamina_recovery_speed: float
@export var awareness_recovery_speed: float
@export_range(0.0, 1.0, 0.01) var stamina_percent_to_kill: float

@export_group("Player stats")
@export var max_awareness: float

signal get_awareness(damage: float)
signal full_awareness
signal stamina_use(amount: float)
signal guard_killed

func _ready() -> void:
	current_stamina = max_stamina

func _physics_process(delta: float) -> void:
	get_input(delta)
	stats_recovery(delta)
	move()
	
func move() -> void:
	velocity.x = direction_x * current_speed
	velocity.y += Global.GRAVITY_STRENGTH
	move_and_slide()

func jump() -> void: 
	if is_on_floor():
		velocity.y = -jump_strength
		current_stamina -= jump_stamina_usage
		stamina_use.emit(jump_stamina_usage)

func run(delta) -> void:
	is_running = true
	current_speed = stamina_speed
	current_stamina -= stamina_usage * delta
	stamina_use.emit(stamina_usage * delta)
	
func stats_recovery(delta) -> void:
	if not direction_x and stamina_timer.is_stopped():
		stamina_timer.start()
	if direction_x:
		stamina_timer.stop()
		stamina_recovery = false
		
	if stamina_recovery and current_stamina < 100:
		current_stamina += stamina_recovery_speed * delta
		stamina_use.emit(-stamina_recovery_speed * delta)
		
	if awareness_recovery:
		add_awareness(-awareness_recovery_speed * delta)
	
func get_input(delta) -> void:
	current_speed = speed
	direction_x = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump") and current_stamina >= jump_stamina_usage:
		stamina_timer.stop()
		stamina_recovery = false
		jump()
	
	if Input.is_action_pressed("run") and current_stamina > 0 and direction_x:
		run(delta)
		stamina_timer.stop()
		stamina_recovery = false
	else:
		is_running = false
	
	if Input.is_action_just_pressed("kill") and current_stamina >= max_stamina * stamina_percent_to_kill:
		current_stamina = 0.0
		guard_killed.emit()
		
	if Input.is_action_just_pressed("action"):
		for wardrobe in get_tree().get_nodes_in_group("Wardrobes"):
			if wardrobe.is_in_area:
				layer_transition(wardrobe, 4)
						
		for vent in get_tree().get_nodes_in_group("Vents"):
			if vent.is_in_area:
				layer_transition(vent, 2)
				
func layer_transition(object, target_layer: int) -> void:
	if current_awareness < max_awareness / 5:
		if collision_layer == 1:
			z_index = -1
			change_layer(target_layer, object.global_position)
		elif collision_layer == target_layer:
			z_index = 0
			change_layer(1, object.global_position)

func change_layer(layer: int, position: Vector2) -> void:
	global_position = position
	collision_layer = layer
	collision_mask = layer

func add_awareness(damage: float):
	if damage > 0:
		awareness_recovery = false
		awareness_timer.start()
		
	current_awareness += damage
	current_awareness = clamp(current_awareness, 0, max_awareness)
	get_awareness.emit(damage)
	
	if current_awareness >= max_awareness:
		full_awareness.emit()
		
func running() -> bool:
	return is_running

func _on_stamina_timer_timeout() -> void:
	stamina_recovery = true

func _on_awareness_timer_timeout() -> void:
	awareness_recovery = true
