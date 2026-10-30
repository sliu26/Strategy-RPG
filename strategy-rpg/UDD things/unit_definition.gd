class_name UnitDefinition
extends Resource
## basically the same as name variable
enum Type {
	King,
	Two,
}

@export var name: String
@export var type: Type
## sprite textures for annimation
@export var frames: SpriteFrames
## type specific stuff other than other variables goes here
## seems to only matter for mage since attack animation is different
@export var type_components: Array[PackedScene] = []
## defines array of movement options and pathfinding bs for movement
## squares
@export var move_definitions: Array[ActionDefinition]
## defines array of movement options and pathfinding bs for attacking
## area squares
@export var ability_definitions: Array[ActionDefinition]
