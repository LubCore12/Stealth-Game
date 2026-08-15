extends Node

signal bombs_changed()
const GRAVITY_STRENGTH = 20
var is_awareness_full = false
var bombs = 3:
	set(new_value):
		bombs = new_value
		bombs_changed.emit()
var max_bombs = 3
var completed_levels=[]
var current_level_idx=0
