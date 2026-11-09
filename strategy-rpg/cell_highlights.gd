class_name CellHighlights
extends Node2D
@export var grid: Grid

const HIGHLIGHT = preload("res://art/cursor_animation/cursor_frame_1.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignal.highlight_move_acs.connect(on_highlight_move_acs)
	GlobalSignal.highlight_attack_acs.connect(on_highlight_attack_acs)

func on_highlight_move_acs(acs: Array):
	for ac_highlight in self.get_children():
		ac_highlight.queue_free()
	
	for ac in acs:
		highlight_cell(HIGHLIGHT, Color.GREEN, ac.cell, self)

func on_highlight_attack_acs(acs: Array):
	for ac_highlight in self.get_children():
		ac_highlight.queue_free()
	
	for ac in acs:
		highlight_cell(HIGHLIGHT, Color.RED, ac.cell, self)

func highlight_cell(tex: Texture, color: Color, cell: Vector2, parent: Node) -> void:
	var s = Sprite2D.new()
	s.texture = tex
	s.modulate = color ## this is strange syntax but go off ig
	s.position = grid.cell_position_to_global_position(cell)
	parent.add_child(s)

	print(s.position)
