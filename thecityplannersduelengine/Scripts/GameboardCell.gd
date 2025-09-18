class_name GameboardCell

enum LABELS {
	UNLABELED,
	STATIC,
	DYNAMIC,
	FULL_CELL,
	N_SUBCELL, S_SUBCELL, E_SUBCELL, W_SUBCELL,
	N_EDGE, S_EDGE, E_EDGE, W_EDGE, NE_EDGE, NW_EDGE, SE_EDGE, SW_EDGE
}

var row: int
var col: int
var contents: Array[Array] = []

static func create_empty(r: int, c: int) -> GameboardCell:
	var new_cell: GameboardCell = GameboardCell.new()
	new_cell.row = r
	new_cell.col = c
	new_cell.contents = _get_empty_contents()
	return new_cell
	
static func _get_empty_contents() -> Array[Array]:
	var empty_contents: Array[Array] = []
	for i in LABELS.size():
		empty_contents.append([])
	return empty_contents
	
func _to_string() -> String:
	var my_str = "Cell (" + "r: " + str(row) + ", c: " + str(col) + ")"
	return my_str
	
