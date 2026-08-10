extends Control

@onready var awareness_bar = $TopLeftBox/AwarenessBar
@onready var stamina_bar = $TopLeftBox/StaminaBar

func set_awareness(value: float) -> void:
	awareness_bar.value = value
	
func set_stamina(value: float) -> void:
	stamina_bar.value = value
	
func add_awareness(value: float) -> void:
	awareness_bar.value += value

func discard_stamina(value: float) -> void:
	stamina_bar.value -= value
	
