extends Node2D

@onready var player = $Entities/Player
@onready var cameras = $Entities/Cameras
@onready var guardians = $Entities/Guardians
@onready var player_ui = $CanvasLayer/PlayerUI
@onready var panels = $Entities/panels
@onready var wardrobes = $Entities/wardrobes
@onready var laminat = $floor
@onready var vents = $Entities/vents

func _ready() -> void:
	laminat.setup(player,cameras,guardians,panels,wardrobes,vents)
	for camera in cameras.get_children():
		camera.setup(player)
	for wardrobe in wardrobes.get_children():
		wardrobe.setup(player)
	for vent in vents.get_children():
		vent.setup(player)
	for panel in panels.get_children():
		panel.setup(player)
	for guardian in guardians.get_children():
		guardian.setup(player)
	player_ui.set_stamina(player.stamina)
	player_ui.set_awareness(0)
	
func _on_player_stamina_use(amount: float) -> void:
	player_ui.discard_stamina(amount)

func _on_player_get_awareness(damage: float) -> void:
	player_ui.add_awareness(damage)

func _on_player_full_awareness() -> void:
	player_ui.full_awareness()
	Global.is_awareness_full=true

func _on_player_guard_killed() -> void:
	for guardian in guardians.get_children():
		guardian.dead()
