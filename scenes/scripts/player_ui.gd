extends Control

@onready var awareness_bar = $HBoxContainer/TopLeftBox/AwarenessBar
@onready var stamina_bar = $HBoxContainer/TopLeftBox/StaminaBar
@onready var signal_danger = $HBoxContainer/signal_danger

func set_awareness(value: float) -> void:
	awareness_bar.value = value

func set_stamina(value: float) -> void:
	stamina_bar.value = value
	
func add_awareness(value: float) -> void:
	awareness_bar.value += value
	awareness_bar.value=clamp(awareness_bar.value,0,100)
	if awareness_bar.value<100:
		signal_danger.hide()

func discard_stamina(value: float) -> void:
	stamina_bar.value -= value
	
func full_awareness() -> void:
	signal_danger.show()
