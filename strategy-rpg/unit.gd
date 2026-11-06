class_name Unit
extends Node2D


###### all below cell position declaration is the same in cursor script######

@export var unit_definition: UnitDefinition

@export var grid: Resource
@export var health: int = 2

@export var cell: Vector2 = Vector2.ZERO:
	set(value):
		cell = value
		global_position = grid.cell_position_to_global_position(cell)

var is_active: bool = true

func _ready() -> void:
	global_position = grid.cell_position_to_global_position(cell)

func unit_hit() -> void:
	health -= 1
	print(self.name, " was hit!")
	print(self.name, " health: ", health)
	if health <= 0:
		is_active = false
		print(self.name, " has been slain!")
