extends CharacterBody2D

@onready var aw_timer=$Timers/AwarenessTimer
@onready var stam_timer=$Timers/StaminaTimer

var direction_x: float
var current_awareness: float
var current_speed: float
var stamina_recovery := false
var aw_recovery := false

@export_group("Movement")
@export var speed: float
@export var jump_time_max: float
@export var jump_strength: float
@export var stamina: float
@export var stamina_speed: float
@export var stamina_usage: float
@export var jump_stamina_usage: float
@export var kill_aw_usage: float
@export var stamina_recovery_speed: float
@export var awareness_recovery_speed: float


@export_group("Player stats")
@export var max_awareness: float

signal get_awareness(damage: float)
signal full_awareness
signal stamina_use(amount: float)
signal guard_killed

func _physics_process(delta: float) -> void:
	get_input(delta)
	move()
	
func move() -> void:
	velocity.x = direction_x * current_speed
	velocity.y += Global.GRAVITY_STRENGTH
	move_and_slide()

func jump() -> void: 
	if is_on_floor():
		velocity.y = -jump_strength
		stamina -= jump_stamina_usage
		stamina_use.emit(jump_stamina_usage)

func run(delta) -> void:
	current_speed = stamina_speed
	stamina -= stamina_usage * delta
	stamina_use.emit(stamina_usage * delta)
	
func get_input(delta) -> void:
	current_speed = speed
	direction_x = Input.get_axis("left", "right")
	
	if not direction_x and stam_timer.is_stopped():
		stam_timer.start()
	if direction_x:
		stam_timer.stop()
		stamina_recovery = false
		
	if stamina_recovery and stamina < 100:
		stamina += stamina_recovery_speed * delta
		stamina_use.emit(-stamina_recovery_speed * delta)
	if aw_recovery:
		add_awareness(-awareness_recovery_speed * delta)
	
	if Input.is_action_just_pressed("jump") and stamina >= jump_stamina_usage:
		stam_timer.stop()
		stamina_recovery = false
		jump()
	
	if Input.is_action_pressed("run") and stamina > 0 and direction_x:
		run(delta)
		stamina_recovery = false
		stam_timer.stop()
	
	if Input.is_action_just_pressed("kill") and current_awareness < kill_aw_usage:
		guard_killed.emit()

func add_awareness(damage: float):
	if damage > 0:
		aw_recovery = false
		aw_timer.start()
		
	current_awareness += damage
	current_awareness = clamp(current_awareness, 0, max_awareness)
	get_awareness.emit(damage)
	
	if current_awareness >= max_awareness:
		full_awareness.emit()

func _on_stamina_timer_timeout() -> void:
	stamina_recovery = true

func _on_awareness_timer_timeout() -> void:
	aw_recovery = true

func _on_vent_system_vent_used() -> void:
	if current_awareness < max_awareness / 5:
		if collision_layer == 1:
			global_position.y = -100
			collision_layer = 2
			collision_mask = 2
		elif collision_layer == 2:
			collision_layer = 1
			collision_mask = 1
		

func _on_wardrobe_used() -> void:
	if current_awareness < max_awareness / 5:
		if collision_layer == 1:
			z_index = -1
			global_position.y = -30
			collision_layer = 4
			collision_mask = 4
		elif collision_layer == 4:
			z_index = 0
			collision_layer = 1
			collision_mask = 1
