extends CharacterBody2D

var direction_x: float
var current_awareness: float
var current_speed: float
var stamina_recovery := false

@export_group("Movement")
@export var speed: float
@export var jump_strength: float
@export var stamina: float
@export var stamina_speed: float
@export var stamina_usage: float
@export var stamina_recovery_speed: float

@export_group("Player stats")
@export var max_awareness: float

signal get_awareness(damage: float)
signal full_awareness
signal stamina_use(amount: float)

func _physics_process(delta: float) -> void:
	get_input(delta)
	move()
	
func move() -> void:
	velocity.x = direction_x * current_speed
	velocity.y += Global.GRAVITY_STRENGTH
	move_and_slide()
	
func jump() -> void:
	velocity.y = -jump_strength
	
func run(delta) -> void:
	current_speed = stamina_speed
	stamina -= stamina_usage * delta
	stamina_use.emit(stamina_usage * delta)
	
func get_input(delta) -> void:
	current_speed = speed
	direction_x = Input.get_axis("left", "right")
	
	if not direction_x and $Timers/StaminaTimer.is_stopped():
		$Timers/StaminaTimer.start()
	if direction_x:
		$Timers/StaminaTimer.stop()
		stamina_recovery = false
		
	if stamina_recovery:
		stamina += stamina_recovery_speed * delta
		stamina_use.emit(-stamina_recovery_speed * delta)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
		
	if Input.is_action_pressed("run") and stamina > 0 and direction_x:
		run(delta)

func add_awareness(damage: float):
	current_awareness += damage
	get_awareness.emit(damage)
	
	if current_awareness >= max_awareness:
		full_awareness.emit()

func _on_stamina_timer_timeout() -> void:
	stamina_recovery = true
