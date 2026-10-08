extends CharacterBody2D
# Makes the card unselected by default. #
var selected := false
func _ready() -> void:
	# Puts the card on tile (1,1) on instantiation. #
	global_position += Vector2(8.0, 8.0)
var former_position := global_position
# Get grabbed when the cursor is on it and the player selects. #
# Or, get dropped when the player deselects while grabbing. #
func _process(_delta):
	if Input.is_action_pressed("select") and %PlayerCursor.global_position == global_position and !selected and !%Variables.selected:
		selected = true
		former_position = global_position
		%Variables.selected = true
	elif Input.is_action_pressed("deselect") and selected:
		selected = false
		global_position = former_position
		%Variables.selected = false
# Move when selected. #
func _physics_process(_delta: float) -> void:
	if selected:
				global_position = %PlayerCursor.global_position
