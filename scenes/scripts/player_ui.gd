extends Control

@onready var awareness_bar = $HBoxContainer/TopLeftBox/AwarenessBar
@onready var stamina_bar = $HBoxContainer/TopLeftBox/StaminaBar
@onready var signal_danger = $HBoxContainer/signal_danger
@onready var bombs = $bombs
@onready var pause = $pause
var bombs_count=Global.max_bombs

func set_awareness(value: float) -> void:
	awareness_bar.value = value

func set_stamina(value: float) -> void:
	stamina_bar.value = value

func set_bombs() -> void:
	var max_=Global.max_bombs
	var count=Global.bombs
	if count<=bombs_count:
		bombs.get_child(bombs_count-1).modulate=Color()
	else:
		for i in range(count):
			bombs.get_child(max_-i-1).modulate=Color(1.0, 1.0, 1.0, 1.0)
	bombs_count=count

func add_awareness(value: float) -> void:
	var tween = create_tween()
	tween.tween_property(awareness_bar, "value", awareness_bar.value + value, 0.1)
	
	awareness_bar.value = clamp(awareness_bar.value, 0, 100)
	
	if awareness_bar.value < 100:
		signal_danger.hide()

func discard_stamina(value: float) -> void:
	stamina_bar.value -= value
	
func full_awareness() -> void:
	signal_danger.show()

func _on_pause_button_pressed() -> void:
	get_tree().paused=true
	pause.show()
