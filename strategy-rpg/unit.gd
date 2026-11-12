class_name Unit
extends Node2D


###### all below cell position declaration is the same in cursor script######
var held: bool = false
var has_moved: bool = false
var ability_used: bool = false
@onready var unit_animation = $UnitAnimation
@onready var cursor = %Cursor as Cursor
@export var unit_def: UnitDefinition


@export var grid: Grid
@export var health: int = 2
var unit_animation_tween: Tween
var yoked: bool = false
var init_cell: Vector2
var turn_finished: bool = false
@export var cell: Vector2 = Vector2.ZERO:
	set(value):
		cell = value
		global_position = grid.cell_position_to_global_position(cell)

var is_active: bool = true
func _process(delta: float) -> void:
	if yoked:
		cell = cursor.cell
		unit_animation.global_position = cursor.cursor_animation.global_position

func _ready() -> void:
	global_position = grid.cell_position_to_global_position(cell)

func _move_to_init_cell():
	var pos = cell
	cell = init_cell
	unit_animation.cell = pos
	unit_animation_tween = create_tween()
	unit_animation_tween.tween_property(unit_animation, "cell", init_cell, 0.1)
	yoked = false




func unit_hit() -> void:
	health -= 1
	print(self.name, " was hit!")
	print(self.name, " health: ", health)
	if health <= 0:
		is_active = false
		print(self.name, " has been slain!")
