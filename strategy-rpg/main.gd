extends Node2D

##### Initializes Level and starts player turn ####

@onready var game_board: GameBoard = $GameBoard 

func _ready() -> void:
	game_board.start_battle()
	pass 
