extends AnimatedSprite2D
@export var grid: Grid

var cell: Vector2 = Vector2.ZERO:
	set(value):
		cell = value
		global_position = grid.cell_position_to_global_position(cell)
