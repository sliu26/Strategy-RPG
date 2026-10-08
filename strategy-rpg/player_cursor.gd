extends CharacterBody2D

@onready var arrow_trail: PackedScene
@onready var arrow_head: PackedScene
@onready var arrow_scene: PackedScene
# Defines default cursor speed and allows you to change it. #
# Default is two tiles/sec. #
@export_range(0.0, 1.0) var cursor_speed := 0.5
# Defines tile size. Determines unit distance of cursor. #
const TILE_SIZE := Vector2(16, 16)
# Sets the cursor to be able to move by default. #
var can_move := true
# Sets the cursor to be stationary by default. #
var player_direction := Vector2(0.0, 0.0)

func _ready() -> void:
	# Puts the cursor in the middle of a tile on instantiation. #
	global_position += TILE_SIZE/2


func _physics_process(_delta: float) -> void:
	# Gets the directional vector from the player's inputs. #
	player_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# Causes the cursor to move if there are inputs being made. #
	if player_direction != Vector2.ZERO and can_move:
		move()
# Defines move(). #
func move() -> void:
	can_move = false
	# Creates a buffer that makes diagonal inputs easier. #
	await get_tree().create_timer(0.025).timeout
	# Updates cursor position by up to one tile by player_direction. #
	global_position += player_direction * TILE_SIZE
	# Briefly prevents move() from activating for QOL. #
	await get_tree().create_timer(cursor_speed).timeout
	can_move = true
