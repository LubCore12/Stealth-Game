extends Node2D

@export_group("stats")
@export var add: float
@export var chanse_guard: float
@export var chanse_vent: float
@export var chanse_cam: float
@export var chanse_panel: float
@export var chanse_wardrobe: float

@onready var shape=$StaticBody2D/Shape.shape as RectangleShape2D
@onready var pos=$StaticBody2D/Shape
@onready var left=$StaticBody2D/left
@onready var right=$StaticBody2D/right

var camera_scene=preload("res://scenes/camera.tscn")
var guard_scene=preload("res://scenes/guardian.tscn")
var panel_scene=preload("res://scenes/control_panel.tscn")
var vent_sist_scene=preload("res://scenes/vent_sistem.tscn")
var vent_scene=preload("res://scenes/vent.tscn")
var wardrobe_scene=preload("res://scenes/wardrobe.tscn")

var cams
var guards
var panels
var player
var wardrobes
var vents

func setup(body,cameras,guardians,pans,robes,vens):
	player=body
	cams=cameras
	guards=guardians
	panels=pans
	vents=vens
	wardrobes=robes

func _on_left_body_entered(body: Node2D) -> void:
	if body==player:
		call_deferred("expand_left")

func _on_right_body_entered(body: Node2D) -> void:
	if body==player:
		call_deferred("expand_right")

func spawn(basis_right):
	var x=add*basis_right+player.position.x
	if randf()<chanse_cam:
		var camera=camera_scene.instantiate()
		cams.add_child(camera)
		camera.global_position.y=-90
		camera.global_position.x=x
		camera.setup(player)
		x-=150*basis_right
		if randf()<chanse_panel:
			var panel=panel_scene.instantiate()
			panels.add_child(panel)
			panel.global_position.y=-45
			panel.global_position.x=x
			panel.setup(player)
			panel.panel_used.connect(camera._on_control_panel_used)
	if randf()<chanse_guard:
		var guard=guard_scene.instantiate()
		guards.add_child(guard)
		guard.global_position.y=-30
		guard.global_position.x=x
		guard.setup(player)
	if randf()<chanse_wardrobe:
		var wardrobe=wardrobe_scene.instantiate()
		wardrobes.add_child(wardrobe)
		wardrobe.global_position.y=-30
		wardrobe.global_position.x=x
		wardrobe.setup(player)
	if randf()<chanse_vent:
		var vent_sist=vent_sist_scene.instantiate()
		vent_sist.flip=(basis_right!=1)
		vents.add_child(vent_sist)
		vent_sist.setup(player)
		vent_sist.global_position.y=-70
		vent_sist.global_position.x=x
		var vents_count=1
		var children=[]
		for i in range(5):
			if randf()<1.0/vents_count:
				children.append(vent_scene.instantiate())
				vents_count+=1
			else:
				break
		vent_sist.add_vent(children)

func expand_left():
	shape.size.x += add
	pos.position.x -= add/2.0
	left.position.x-=add
	spawn(-1)
func expand_right():
	shape.size.x += add
	pos.position.x += add/2.0
	right.position.x+=add
	spawn(1)
