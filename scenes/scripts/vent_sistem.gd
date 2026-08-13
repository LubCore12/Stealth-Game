extends Node2D

@onready var colrect=$ColorRect
@onready var vents=$vents
@onready var polygon=$StaticBody2D/CollisionPolygon2D

@export_group("stats")
@export var dist: float
@export var flip: bool

var player
signal vent_used

func setup(body):
	player=body
	for child in vents.get_children():
		child.setup(player)
	expand()

func add_vent(children):
	for i in children:
		vents.add_child(i)
		i.setup(player)
		vent_used.connect(player._on_vent_sistem_vent_used)
	expand()

func expand():
	var vent_count=0
	var add
	for vent in vents.get_children():
		vent.setup(player)
		add=vent_count*dist
		vent.position.x+=add
		vent_count-=1 if flip else -1
	var pol=polygon.polygon
	var points
	if flip:
		vents.position.x-=110
		points=[1,0,6,7]
		colrect.position.x+=add
		vents.get_child(0).position.x+=50
	else:
		points=[2,3,4,5,8,9,10,11]
		vents.get_child(-1).position.x-=100
	for i in points:
		pol[i].x+=add
	polygon.polygon=pol
	colrect.size.x=abs(add)

func _on_vent_used() -> void:
	vent_used.emit()
	if player.collision_layer==1:
		colrect.z_index=-1
		for vent in vents.get_children():
			vent.z_index=-1
	else:
		colrect.z_index=0
		for vent in vents.get_children():
			vent.z_index=0
