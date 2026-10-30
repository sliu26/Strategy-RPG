class_name CellHighlights
extends Node2D
@export var grid: Grid

const HIGHLIGHT = preload("res://art/player-cursor-awesome-mode.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.
func highlight_move_acs(acs: Array[ActionDefinition], unit: Unit):
	for ac_highlight in self.get_children():
		ac_highlight.queue_free()
	
	for ac in acs:
		var relative_ac_endpoint := unit.cell + ac.end_point
		highlight_cell(HIGHLIGHT, Color.GREEN, relative_ac_endpoint, self)

func highlight_attack_acs(acs: Array[ActionDefinition], unit: Unit):
	for ac_highlight in self.get_children():
		ac_highlight.queue_free()
	
	for ac in acs:
		var relative_ac_endpoint := unit.cell + ac.end_point
		highlight_cell(HIGHLIGHT, Color.RED, relative_ac_endpoint, self)

func highlight_cell(tex: Texture, color: Color, cell: Vector2, parent: Node) -> void:
	var s = Sprite2D.new()
	s.texture = tex
	s.modulate = color ## this is strange syntax but go off ig
	s.position = grid.cell_position_to_global_position(cell)
	parent.add_child(s)

	print(s.position)
