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

var current_acs: Array

## Sets the cursor to be able to move by default. 

## Sets the cursor to be stationary by default. 
var player_direction: Vector2 = Vector2.ZERO
## cursor isn't selecting anything by default
## the time it takes before cusor is able to move again
var ui_cooldown: float = 0.25
var move_cell: Vector2 
var booool: bool = true

func start_battle(): 
	current_unit = get_active_units()[current_unit_index]
	current_unit.has_moved = false
	current_unit.ability_used = false
	pass



## checks for inputs from player and categorizes them
func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("select"):
		# selection phase
		
			
		if (!current_unit.held and !current_unit.has_moved) or current_unit.ability_used:
			for unit in get_active_units():
				if unit.cell == cursor.cell:
					current_unit = unit
				else: 
					print("error")

		if current_unit.held == false and current_unit.has_moved == false:

			current_unit.init_cell = current_unit.cell 
			yoke_cursor_to_unit(current_unit)
			current_acs = get_move_acs(current_unit)
			## elaborate on this code to have script display end points as
			## highlighted board cells
			GlobalSignal.highlight_move_acs.emit(current_acs)
			return

	# move phase
		elif current_unit.held and current_unit.has_moved == false:

			for ac: ActionInstance in current_acs:
				if ac.cell == cursor.cell:
					current_unit.held = false
					current_unit.has_moved = true
					current_acs = get_ability_acs(current_unit)
					GlobalSignal.highlight_ability_acs.emit(current_acs)
					return
			print("error")
		# action phase
		elif current_unit.has_moved and current_unit.ability_used == false:
			for ac: ActionInstance in current_acs:
				if ac.cell == cursor.cell:
					current_unit.turn_finished = true
					current_unit.ability_used = true
					current_unit.modulate = Color.GRAY
					check_turn_status()
					current_acs = []
					GlobalSignal.highlight_ability_acs.emit([])
					for enemy_unit in get_active_units():
						if enemy_unit.cell == cursor.cell:
							enemy_unit.unit_hit()
							return
					print("miss!")
					return
			print("error")



	## deselect only functions after select is pressed on a unit containing cursor.cell
	elif event.is_action_pressed("deselect") and !current_unit.turn_finished :
		current_unit._move_to_init_cell()
		current_unit.held = false
		current_unit.has_moved = false
		GlobalSignal.highlight_ability_acs.emit([])
		GlobalSignal.highlight_move_acs.emit([])
		current_acs = []
		


## directional inputs move cursor by one cursor.cell
	#elif event.is_action("move_right"):
		#if event.is_released():
			#cursor.cell += Vector2.RIGHT
		#while event.is_echo():
			#await get_tree().create_timer(ui_cooldown).timeout
			#while event.is_released() == false:
				#cursor.cell += Vector2.RIGHT
				#await get_tree().create_timer(ui_cooldown).timeout
#
#
#
	#elif event.is_action("move_up") and event.is_released():
		#cursor.cell += Vector2.UP
		#
	#elif event.is_action("move_left") and event.is_released():
		#cursor.cell += Vector2.LEFT
		#
	#elif event.is_action("move_down") and event.is_released():
		#cursor.cell += Vector2.DOWN


func get_active_units() -> Array[Unit]:
	var active_units: Array[Unit]
	
	for group in self.get_children():
		for unit in group.get_children():
			if unit.is_active == true:
				active_units.append(unit)
	return active_units

func check_turn_status():
	var n: int = 0
	for unit: Unit in get_active_units():
		if unit.turn_finished:
			n += 1
			unit.init_cell = unit.cell
	if n == get_active_units().size():
		step_turn()

func step_turn():
	for unit: Unit in get_active_units():
		unit.held = false
		unit.has_moved = false
		unit.ability_used = false
		unit.turn_finished = false
		unit.modulate = Color.WHITE

func get_move_acs(unit: Unit) -> Array:

	var acs = unit.unit_def.move_def.map(
			func (move_def):
				## you need to declare this as action instance or else will return
				## 
				return move_def.to_action_instance(current_unit) as ActionInstance
				)
	return acs


func get_ability_acs(unit: Unit) -> Array:
	var acs = unit.unit_def.ability_def.map(
			func (ability_def):
				## you need to declare this as action instance or else will return
				## 
				return ability_def.to_action_instance(current_unit) as ActionInstance
				)
	return acs

## keeps unit yoked to cursor until deselect is pressed
func yoke_cursor_to_unit(unit: Unit) -> void:
	unit.held = true
	while unit.held:
		unit.yoked = true
		await cursor.cursor_moved
	unit.yoked = false
