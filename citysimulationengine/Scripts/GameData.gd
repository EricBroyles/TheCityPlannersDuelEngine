extends Node

## World
var world_px_per_cell: int
var world_px: Vector2i
var mouse_screen_float_px: Vector2
var mouse_screen_px: Vector2i
var mouse_world_px: Vector2i
var mouse_cell_idx: Vector2i
var screen_px_size: Vector2i #screen width and height in px
var screen_cell_size: Vector2i #screen width and height in cell

## Colors
var EMPTY_COLOR: Color = Color(0,0,0,0)
