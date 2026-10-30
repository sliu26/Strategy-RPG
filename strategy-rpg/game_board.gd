class_name GameBoard
extends Node2D

## inherits grid resource
@export var grid: Grid
@onready var cursor: Cursor = %Cursor 
@onready var cell_highlights: CellHighlights = %CellHighlights
## sets initial cursor position

var current_group: Node
var current_group_index: int = 0
var current_unit_index: int = 0
var current_unit: Unit
var has_moved: bool = false
var has_attacked: bool = false
var current_acs: Array

## Sets the cursor to be able to move by default. 
var can_move: bool = true
## Sets the cursor to be stationary by default. 
var player_direction: Vector2 = Vector2.ZERO
## cursor isn't selecting anything by default
var unit_held: bool = false
## the time it takes before cusor is able to move again
var ui_cooldown: float = 0.15


func start_battle(): 
	current_unit = get_active_units()[current_unit_index]
	has_moved = false
	has_attacked = false
	pass

func step_turn():
	#if has_attacked == false and has_moved == true:
				## elaborate on this code to have script display end points as
				## highlighted board cells
				#cell_highlights.highlight_attack_acs(unit.unit_definition.ability_definitions, unit)
	pass

## checks for inputs from player and categorizes them
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("select"):
		## finds current unit and then calls yoke_cursor_to_unit
		if has_moved and has_attacked == false and event.is_released():
			has_attacked = true
			print("hayah!")
			has_attacked = false
			has_moved = false

		if unit_held and has_moved == false and event.is_released():
			unit_held = false
			has_moved = true
			cell_highlights.highlight_attack_acs(current_unit.unit_definition.move_definitions, current_unit)


			

			
			
			
		for unit in get_active_units():
			## code for move phase
			if unit.cell == cursor.cell and unit_held == false and has_moved == false and event.is_released():
				
				current_unit = unit
				yoke_cursor_to_unit(current_unit)
				## elaborate on this code to have script display end points as
				## highlighted board cells
				cell_highlights.highlight_move_acs(current_unit.unit_definition.move_definitions, current_unit)
			## code for attack phase
			
		#GlobalSignal.select_pressed.emit(cursor.cell)
		
		
		
## deselect only functions after select is pressed on a unit containing cursor.cell
	elif event.is_action("deselect"):
		pass


## directional inputs move cursor by one cursor.cell
	elif event.is_action("move_right") and can_move:
		can_move = false
		cursor.cell += Vector2.RIGHT
		await get_tree().create_timer(ui_cooldown).timeout
		can_move = true
	
	elif event.is_action("move_up") and can_move:
		can_move = false
		cursor.cell += Vector2.UP
		await get_tree().create_timer(ui_cooldown).timeout
		can_move = true
		
	elif event.is_action("move_left") and can_move:
		can_move = false
		cursor.cell += Vector2.LEFT
		await get_tree().create_timer(ui_cooldown).timeout
		can_move = true
		
	elif event.is_action("move_down") and can_move:
		can_move = false
		cursor.cell += Vector2.DOWN
		await get_tree().create_timer(ui_cooldown).timeout
		can_move = true

func get_active_units() -> Array[Unit]:
	
	var active_units: Array[Unit]
	
	for group in self.get_children():
		for unit in group.get_children():
			active_units.append(unit)
	return active_units



## keeps unit yoked to cursor until deselect is pressed

func yoke_cursor_to_unit(unit: Unit) -> void:
	await get_tree().create_timer(ui_cooldown).timeout
	unit_held = true
	while unit_held:
		unit.cell = cursor.cell
		await cursor.cursor_moved
