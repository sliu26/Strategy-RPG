extends Node2D

## emited when unit is selected by cursor
signal unit_held(unit: Unit)

var selected_unit: Unit
## dictionary that holds values for unit node and cell
## cells are keys and nodes are values
var _units := {}

func _ready() -> void:
	create_unit_dictionary()

## places child nodes with type Unit into dictionary
func create_unit_dictionary() -> void:
	for child in get_children():
		var unit := child as Unit
		if unit is not Unit:
			continue
		_units[unit.cell] = unit

## emits unit held signal when selected square contains a unit
func _on_cursor_select_pressed(cell: Variant) -> void:
	if _units.has(cell):
		selected_unit = _units.get(cell)
		emit_signal("unit_held", _units.get(cell))

## updates units dictionary when unit is dropped and position changes
func _on_cursor_drop_unit(cell: Variant) -> void:
	_units.erase(selected_unit.cell)
	_units[cell] = selected_unit
