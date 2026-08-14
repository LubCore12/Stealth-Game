extends Node2D

var player: CharacterBody2D

@onready var backround = $VentBG
@onready var vents = $Vents
@onready var polygon = $VentHitboxes/Polygon

@export_group("Vent stats")
@export var dist: float
@export var flip: bool

func setup(body):
	player = body
	for vent in vents.get_children():
		vent.setup(player)
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
