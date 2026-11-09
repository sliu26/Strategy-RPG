class_name ActionDefinition
extends Resource


@export var end_point: Vector2
# Called when the node enters the scene tree for the first time.
func to_action_instance(unit: Unit):
	var ac = ActionInstance.new(self, unit) as ActionInstance
	ac.cell = end_point + unit.cell
	return ac
