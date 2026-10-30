class_name Unit
extends Node2D


###### all below cell position declaration is the same in cursor script######

@export var unit_definition: UnitDefinition

@export var grid: Resource

@export var cell: Vector2 = Vector2.ZERO:
	set(value):
		cell = value
		global_position = grid.cell_position_to_global_position(cell)

func _ready() -> void:
	global_position = grid.cell_position_to_global_position(cell)
	
