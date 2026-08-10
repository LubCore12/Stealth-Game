extends Node2D

@onready var player = $Entities/Player
@onready var cameras = $Entities/Cameras
@onready var guardians = $Entities/Guardians
@onready var player_ui = $CanvasLayer/PlayerUI

func _ready() -> void:
	for camera in cameras.get_children():
		camera.setup(player)
	for guardian in guardians.get_children():
		guardian.setup(player)
	player_ui.set_stamina(player.stamina)
	player_ui.set_awareness(0)
	
func _on_player_stamina_use(amount: float) -> void:
	player_ui.discard_stamina(amount)

func _on_player_get_awareness(damage: float) -> void:
	player_ui.add_awareness(damage)
