extends Node2D

var player: CharacterBody2D

@onready var backround = $VentBG
@onready var vents = $Vents
@onready var polygon = $VentHitboxes/Polygon

@export_group("Vent stats")
@export var dist: float
@export var flip: bool
@export var vents_count: int

var vent_scene=preload("res://scenes/vent.tscn")
var player
signal vent_used(pos)

func setup(body):
	player = body
	for i in range(vents_count-1):
		var vent=vent_scene.instantiate()
		vents.add_child(vent)
		vent.vent_used.connect(_on_vent_used)
	for child in vents.get_children():
		child.setup(player)
	expand()

func expand():
	var pol = polygon.polygon
	var vent_count := 0
	var add := 0.0
	var length = dist * (vents.get_children().size() - 1)
	
	for vent in vents.get_children():
		vent.setup(player)
		add = vent_count * dist
		vent.position.x += add
		vent_count -= 1 if flip else -1
	
	if flip:
		backround.scale.x = -1
		backround.position.x += backround.size.x
		for i in range(pol.size()):
			if pol[i].x < 0: 
				pol[i].x -= length
	else:
		for i in range(pol.size()):
			if pol[i].x > 0: 
				pol[i].x += length
		
	polygon.polygon = pol
	backround.size.x += length

func _on_vent_used(pos) -> void:
	vent_used.emit(pos)
	
	if player.collision_layer == 1:
		backround.z_index = -1
		for vent in vents.get_children():
			vent.z_index = -1
	else:
		backround.z_index = 0
		for vent in vents.get_children():
			vent.z_index = 0
