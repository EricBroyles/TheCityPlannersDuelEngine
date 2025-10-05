extends Node
class_name Gameboard

## Gameboard Builder: requests a modification to the gameboard
## Gameboard: checks if allows to make the modification. if so change the matrix, and then notify the gameboard viewer that a change has happened
## Gameboard Matrix: stores all the information aboout the gameboard 
## Gameboard Viewer: has the tools needed to draw the gameboard on the screen




@onready var gameboard_viewer: GameboardViewer = %GameboardViewer

var matrix: GameboardMatrix

func _ready() -> void:
	matrix = GameboardMatrix.create_empty(EngineData.GB_ROWS, EngineData.GB_COLS)
	
	
	
func attempt_add(item_type: int, cells: Array[GameboardCell]) -> bool:
	#ITEM label, GameboardCells to add to  need to convert the mesh into the cell
	return false

func attempt_remove(item_type: int, cells: Array[GameboardCell]) -> bool:
	return false

#func mesh_to_cells(component: GameboardComponent, mesh: MeshInstance2D) -> Array[GameboardCell]:
	##convert a mesh into gameboard cell
	##add a new component to each gameboardcell subcell
	#
	
	

	
