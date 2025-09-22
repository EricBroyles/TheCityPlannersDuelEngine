##Global
extends Node

const GB_ROWS: int = 100
const GB_COLS: int = 100
const GB_CELL_WIDTH: int = 10 #px

var mouse_position: Vector2

enum INPUT_STATES {
	NONE,
	ROAD,
	WALKWAY,
	BARRIER, #?
	DIRECTION_ARROWS,  #?
}
var input_state: int = INPUT_STATES.NONE
