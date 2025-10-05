class_name GameboardCell

enum LABELS {
	UNLABELED,
	FULL_CELL,
	N_SUBCELL, S_SUBCELL, E_SUBCELL, W_SUBCELL,
	N_EDGE, S_EDGE, E_EDGE, W_EDGE, NE_EDGE, NW_EDGE, SE_EDGE, SW_EDGE
}

var row: int
var col: int
var contents: Dictionary = {} # each label will map to an Array

static func create_empty(r: int, c: int) -> GameboardCell:
	var new_cell: GameboardCell = GameboardCell.new()
	new_cell.row = r
	new_cell.col = c
	new_cell.contents = _get_empty_contents()
	return new_cell

static func _get_empty_contents() -> Dictionary:
	var empty_contents: Dictionary = {}
	for label_name in LABELS.keys():
		empty_contents[LABELS[label_name]] = [] 
	return empty_contents

func _to_string() -> String:
	return "Cell (r: %s, c: %s)" % [row, col]
