class_name ActionInstance
extends RefCounted

var definition: ActionDefinition
var unit: Unit
var cell: Vector2
var poop = "aksdjf"

func _init(action_def: ActionDefinition, source_unit: Unit) -> void:
	definition = action_def
	unit = source_unit
