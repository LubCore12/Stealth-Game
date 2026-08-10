extends Node2D

func _ready() -> void:
	for camera in $Entities/Cameras.get_children():
		camera.setup($Entities/Player)
	for guardian in $Entities/Guardians.get_children():
		guardian.setup($Entities/Player)
	$CanvasLayer/PlayerUI/TopLeftBox/StaminaBar.value = $Entities/Player.stamina

func _on_player_get_damage(damage: float) -> void:
	$CanvasLayer/PlayerUI/TopLeftBox/HealthBar.value += damage

func _on_player_stamina_use(amount: float) -> void:
	$CanvasLayer/PlayerUI/TopLeftBox/StaminaBar.value -= amount
