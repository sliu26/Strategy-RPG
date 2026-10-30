class_name Cursor
extends Node2D


###### all below cell position declaration is the same in cursor script######

signal cursor_moved

@export var grid: Resource

@export var cell: Vector2 = Vector2.ZERO:
	set(value):
		cell = value
		global_position = grid.cell_position_to_global_position(cell)
		cursor_moved.emit()

func _ready() -> void:
	global_position = grid.cell_position_to_global_position(cell)
	
func _draw() -> void:
	draw_rect(Rect2(-grid.HALF_OF_CELL_SIZE, grid.CELL_SIZE), Color.ALICE_BLUE, false, 1.0)
