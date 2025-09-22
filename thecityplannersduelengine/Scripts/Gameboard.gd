extends Node
class_name Gameboard

@onready var gameboard_viewer: GameboardViewer = %GameboardViewer

var matrix: GameboardMatrix

func _ready() -> void:
	matrix = GameboardMatrix.create_empty(EngineData.GB_ROWS, EngineData.GB_COLS)
