extends CharacterBody2D

@onready var arrow_trail: PackedScene
@onready var arrow_head: PackedScene
@onready var arrow_scene: PackedScene

@export_range(0.0, 1.0) var cursor_speed := 0.5
const TILE_SIZE := Vector2(16, 16)
var can_move = true
var player_direction := Vector2(0.0, 0.0)


func _ready() -> void:
	global_position += TILE_SIZE/2


func _physics_process(delta: float) -> void:
	player_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if player_direction != Vector2.ZERO and can_move:
		move()
	move_and_slide()

func move() -> void:
	can_move = false
	await get_tree().create_timer(0.025).timeout
	global_position += player_direction * TILE_SIZE
	
	await get_tree().create_timer(cursor_speed).timeout
	can_move = true
