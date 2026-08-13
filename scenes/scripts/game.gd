extends Node2D

@onready var player = $Entities/Player
@onready var cams = $Entities/Cameras
@onready var stretches = $Entities/Stretches
@onready var guards = $Entities/Guardians
@onready var player_ui = $CanvasLayer/PlayerUI
@onready var panels = $Entities/Panels
@onready var wardrobes = $Entities/Wardrobes
@onready var vents = $Entities/Vents

var camera_scene = preload("res://scenes/camera.tscn")
var guard_scene = preload("res://scenes/guardian.tscn")
var panel_scene = preload("res://scenes/control_panel.tscn")
var vent_sist_scene = preload("res://scenes/vent_system.tscn")
var vent_scene = preload("res://scenes/vent.tscn")
var wardrobe_scene = preload("res://scenes/wardrobe.tscn")
var menu_scene = "res://scenes/menu.tscn"

func _ready() -> void:
	for camera in cams.get_children():
		camera.setup(player)
		
	for wardrobe in wardrobes.get_children():
		wardrobe.setup(player)
		
	for vent in vents.get_children():
		vent.setup(player)
		
	for panel in panels.get_children():
		panel.setup(player)
		
	for guardian in guards.get_children():
		guardian.setup(player)
		guardian.connect("defeat", defeat)
	
	for stretch in stretches.get_children():
		stretch.setup(player)
		
	player_ui.set_stamina(player.max_stamina)
	player_ui.set_awareness(0)
	
func defeat() -> void:
	get_tree().call_deferred("change_scene_to_file", menu_scene)
	
func _on_left_body_entered(body: Node2D) -> void:
	if body == player:
		call_deferred("expand_left")

func _on_right_body_entered(body: Node2D) -> void:
	if body == player:
		call_deferred("expand_right")
	
func _on_player_stamina_use(amount: float) -> void:
	player_ui.discard_stamina(amount)

func _on_player_get_awareness(damage: float) -> void:
	player_ui.add_awareness(damage)

func _on_player_full_awareness() -> void:
	player_ui.full_awareness()
	Global.is_awareness_full = true

func _on_player_guard_killed() -> void:
	for guardian in guards.get_children():
		player_ui.set_stamina(0)
		guardian.dead()
