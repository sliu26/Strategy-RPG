class_name Cursor
extends Node2D


###### all below cell position declaration is the same in cursor script######
#@export var cursor_animation: CursorAnimation
@onready var cursor_animation = $CursorAnimation
@onready var game_board = %GameBoard as GameBoard
signal cursor_moved

@export var grid: Resource

@export var cell: Vector2 = Vector2.ZERO:
	set(value):
		cell = value
		global_position = grid.cell_position_to_global_position(cell)
		cursor_moved.emit()
		set_cursor_flash()


func _ready() -> void:
	global_position = grid.cell_position_to_global_position(cell)

func set_cursor_flash() -> void:
	#for unit in game_board.get_active_units():
		#if unit.cell == cell:
			#cursor_animation.play("Flash")
			#return
	for ac in game_board.current_acs:
		if ac.cell == cell:
			cursor_animation.play("Flash")
			return

	cursor_animation.play("Idle")
