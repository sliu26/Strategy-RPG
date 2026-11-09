class_name GameBoard
extends Node2D

## inherits grid resource
@export var grid: Grid
@onready var cursor: Cursor = %Cursor 
## sets initial cursor position

var current_group: Node
var current_group_index: int = 0
var current_unit_index: int = 0
var current_unit: Unit
var has_moved: bool = false
var has_acted: bool = false
var current_acs: Array

## Sets the cursor to be able to move by default. 
var can_move: bool = true
## Sets the cursor to be stationary by default. 
var player_direction: Vector2 = Vector2.ZERO
## cursor isn't selecting anything by default
var unit_held: bool = false
## the time it takes before cusor is able to move again
var ui_cooldown: float = 0.15
var move_cell: Vector2 

func start_battle(): 
	current_unit = get_active_units()[current_unit_index]
	has_moved = false
	has_acted = false
	pass

func step_turn():
	#if has_acted == false and has_moved == true:
				## elaborate on this code to have script display end points as
				## highlighted board cells
				#cell_highlights.highlight_attack_acs(unit.unit_definition.ability_definitions, unit)
	pass

## checks for inputs from player and categorizes them
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("select"):
		# selection phase
		if unit_held == false and has_moved == false and event.is_released():
			for unit in get_active_units():
				if unit.cell == cursor.cell:
					current_unit = unit
					current_acs = current_unit.unit_definition.move_definitions.map(
						func (def):
							## you need to declare this as action instance or else will return
							## 
							return def.to_action_instance(current_unit) as ActionInstance
							)
					
					yoke_cursor_to_unit(current_unit)
					## elaborate on this code to have script display end points as
					## highlighted board cells
					GlobalSignal.highlight_move_acs.emit(current_acs)
					return
			print("error")
		# move phase
		elif unit_held and has_moved == false and event.is_released():

			for ac in current_acs:
				if ac.cell == cursor.cell:
					unit_held = false
					has_moved = true
					current_acs = current_unit.unit_definition.ability_definitions.map(
						func (def):
							## you need to declare this as action instance or else will return
							## 
							return def.to_action_instance(current_unit) as ActionInstance
							)
					GlobalSignal.highlight_attack_acs.emit(current_acs)
					## stops cursor from flashing after valid selection
					cursor.cell = cursor.cell
					return
			print("error")
		# action phase
		elif has_moved == true and has_acted == false and event.is_released():
			for ac in current_acs:
				if ac.cell == cursor.cell:
					current_acs = []
					## stops cursor from flashing after valid selection
					cursor.cell = cursor.cell
					has_acted = true
					has_acted = false
					has_moved = false
					GlobalSignal.highlight_attack_acs.emit([])
					
					for enemy_unit in get_active_units():
						if enemy_unit.cell == cursor.cell:
							enemy_unit.unit_hit()
							return
					print("miss!")
					return
			print("error")



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
			if unit.is_active == true:
				active_units.append(unit)
	return active_units



## keeps unit yoked to cursor until deselect is pressed

func yoke_cursor_to_unit(unit: Unit) -> void:
	await get_tree().create_timer(ui_cooldown).timeout
	unit_held = true
	while unit_held:
		unit.cell = cursor.cell
		await cursor.cursor_moved
