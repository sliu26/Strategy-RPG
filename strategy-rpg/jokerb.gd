extends CharacterBody2D
# Makes the card unselected by default. #
var selected := false
func _ready() -> void:
	# Puts the cursor in the middle of a tile on instantiation. #
	global_position += Vector2(8.0, 8.0)
var former_position := global_position
# Get grabbed when the cursor is on it and the player selects. #
# Or, get dropped when the player deselects while grabbing. #
func _process(_delta):
	if Input.is_action_pressed("select") and %PlayerCursor.global_position == global_position and !selected:
		selected = true
		former_position = global_position
	elif Input.is_action_pressed("deselect") and selected:
		selected = false
		global_position = former_position
# Move when selected. #
func _physics_process(_delta: float) -> void:
	if selected:
				global_position = %PlayerCursor.global_position
