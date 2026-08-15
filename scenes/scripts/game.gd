extends Node2D

@onready var player = $Entities/Player
@onready var cams = $Entities/Cameras
@onready var stretches = $Entities/Stretches
@onready var guards = $Entities/Guardians
@onready var player_ui = $CanvasLayer/PlayerUI
@onready var panels = $Entities/Panels
@onready var wardrobes = $Entities/Wardrobes
@onready var vents = $Entities/Vents
@onready var smoke_bombs = $Entities/smoke_bombs
@onready var defeat_screen = $CanvasLayer/defeat
@onready var stairs = $walls/stairs

var camera_scene = preload("res://scenes/camera.tscn")
var guard_scene = preload("res://scenes/guardian.tscn")
var panel_scene = preload("res://scenes/control_panel.tscn")
var vent_sist_scene = preload("res://scenes/vent_system.tscn")
var vent_scene = preload("res://scenes/vent.tscn")
var wardrobe_scene = preload("res://scenes/wardrobe.tscn")

func _ready() -> void:
	Global.bombs_changed.connect(player_ui.set_bombs)
	
	for camera in cams.get_children():
		camera.setup(player)
		
	for wardrobe in wardrobes.get_children():
		wardrobe.setup(player)
		
	for vent in vents.get_children():
		vent.setup(player)
		
	for panel in panels.get_children():
		panel.setup(player)
		
	for smoke_bomb in smoke_bombs.get_children():
		smoke_bomb.setup(player)
	
	var smoke_area=get_node("Entities/Player/SmokeArea")
	for guardian in guards.get_children():
		guardian.setup(player)
		guardian.connect("player_trapped", _on_guardian_player_trapped)
		smoke_area.connect("body_entered",guardian._on_smoke_body_entered)
	
	for stretch in stretches.get_children():
		stretch.setup(player)
	
	stairs.setup(player)
	
	player_ui.set_stamina(player.max_stamina)
	player_ui.set_awareness(0)

func _on_guardian_player_trapped() -> void:
	Global.bombs-=1
	player.fart()
	if Global.bombs<=0:
		defeat()

func defeat() -> void:
	get_tree().paused=true
	defeat_screen.show()

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
		guardian.dead()
