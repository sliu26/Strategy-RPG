class_name Cursor
extends Node2D


###### all below cell position declaration is the same in cursor script######
@onready var cursor_animation = $CursorAnimation
@onready var game_board = %GameBoard as GameBoard
signal cursor_moved

@export var grid: Grid

@export var cell: Vector2 = Vector2.ZERO:
	set(value):
		cell = value
		global_position = grid.cell_position_to_global_position(cell)
		cursor_moved.emit()
var can_move: bool = true
var cursor_animation_tween: Tween
var hold_time: float
var p: bool = false
var t: int
var current_direction: Vector2

func _ready() -> void:
	global_position = grid.cell_position_to_global_position(cell)

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("move_up"):
		hold_time = 0
		current_direction = Vector2.UP
		if !cursor_animation_tween or !cursor_animation_tween.is_running():
			_move(current_direction)
		else:
			_move_buffer(current_direction)
	elif Input.is_action_just_pressed("move_down"):
		hold_time = 0
		current_direction = Vector2.DOWN
		if !cursor_animation_tween or !cursor_animation_tween.is_running():
			_move(current_direction)
		else:
			_move_buffer(current_direction)
	elif Input.is_action_just_pressed("move_left"):
		hold_time = 0
		current_direction = Vector2.LEFT
		if !cursor_animation_tween or !cursor_animation_tween.is_running():
			_move(current_direction)
		else:
			_move_buffer(current_direction)
	elif Input.is_action_just_pressed("move_right"):
		hold_time = 0
		current_direction = Vector2.RIGHT
		if !cursor_animation_tween or !cursor_animation_tween.is_running():
		
			_move(current_direction)
		else:
			_move_buffer(current_direction)

	elif (!cursor_animation_tween or !cursor_animation_tween.is_running()) and hold_time >= 0.5:
		if (
		Input.is_action_pressed("move_up") or
		Input.is_action_pressed("move_down") or 
		Input.is_action_pressed("move_left")or 
		Input.is_action_pressed("move_right")
		):
			_move(current_direction)

	hold_time += delta
	set_cursor_flash()


func _move_buffer(dir: Vector2):
	await cursor_animation_tween.finished
	_move(dir)

func _move(dir: Vector2):
	cell += dir
	cursor_animation.global_position -= dir * grid.CELL_SIZE
	#cursor_animation_tween.get_instance_id()
	if cursor_animation_tween:
		cursor_animation_tween.kill() ## kills previous tween with empty value so it is removed from memory
		## without this, code would still run normal but tween corpses would pile up in storage
	cursor_animation_tween = create_tween()
	#cursor_animation_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	cursor_animation_tween.tween_property(cursor_animation, "global_position", global_position, 0.1).set_trans(Tween.TRANS_SINE)
	
	#await cursor_animation_tween.finished

func set_cursor_flash() -> void:
	
	for ac in game_board.current_acs:
		if ac.cell == cell:
			cursor_animation.play("Flash")
			return
	cursor_animation.play("Idle")
