class_name Cursor
extends Node2D

## emited whenever cell's position is updated
signal cursor_moved()
## inherits grid resource
@export var grid: Grid
@export var cell: Vector2 = Vector2.ZERO:
	set(value):
		cell = value
		## translates cell vector to global position
		global_position = grid.cell_position_to_global_position(cell)
		cursor_moved.emit()


## Sets the cursor to be able to move by default. 
var can_move: bool = true
## Sets the cursor to be stationary by default. 
var player_direction: Vector2 = Vector2.ZERO
## cursor isn't selecting anything by default
var unit_is_selected: bool = false
## the time it takes before cusor is able to move again
var ui_cooldown: float = 0.15

func _ready() -> void:
	## assigns inital cell value to global position
	global_position = grid.cell_position_to_global_position(cell)
	GlobalSignal.unit_held.connect(_on_unit_held) # callable w/o parenthesis so parameters are built in


## checks for inputs from player and categorizes them
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("select"):
		GlobalSignal.select_pressed.emit(cell)
## deselect only functions after select is pressed on a unit containing cell
	elif event.is_action("deselect"):
		unit_is_selected = false
		GlobalSignal.drop_unit.emit(cell)

## directional inputs move cursor by one cell
	elif event.is_action("move_right") and can_move:
		can_move = false
		cell += Vector2.RIGHT
		await get_tree().create_timer(ui_cooldown).timeout
		can_move = true
	
	elif event.is_action("move_up") and can_move:
		can_move = false
		cell += Vector2.UP
		await get_tree().create_timer(ui_cooldown).timeout
		can_move = true
		
	elif event.is_action("move_left") and can_move:
		can_move = false
		cell += Vector2.LEFT
		await get_tree().create_timer(ui_cooldown).timeout
		can_move = true
		
	elif event.is_action("move_down") and can_move:
		can_move = false
		cell += Vector2.DOWN
		await get_tree().create_timer(ui_cooldown).timeout
		can_move = true

## draws icon for cusor
func _draw() -> void:
	draw_rect(Rect2(-grid.HALF_OF_CELL_SIZE, grid.CELL_SIZE), Color.ALICE_BLUE, false, 1.0)

## keeps unit yoked to cursor until deselect is pressed

func _on_unit_held(unit: Unit) -> void:
	unit_is_selected = true
	while unit_is_selected:
		unit.global_position = global_position
		await cursor_moved
	pass
