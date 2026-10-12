class_name Grid
extends Resource

## denotes length and width of individual cell
const CELL_SIZE := Vector2(16, 16)
## denotes size of grid using amount of cells in each row and collum
const GRID_SIZE := Vector2(25, 15)
## usefull for finding center of cell
const HALF_OF_CELL_SIZE := CELL_SIZE/2

## converts global position vector to cell vector
func global_position_to_cell_position(unit_position: Vector2):
	return (unit_position / CELL_SIZE).floor()

## sets cell value to the middle of the desired square on the board. 
func cell_position_to_global_position(cell: Vector2):
	return (cell * CELL_SIZE) + HALF_OF_CELL_SIZE
