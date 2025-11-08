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
const EMPTY_COLOR: Color = Color(0,0,0,0)
const ROAD: Color = Color("#838688")
const WALKWAY: Color = Color("#C0C5C3")
const CROSSWALK: Color = Color("#EFF0F4")
const PARKING: Color = Color("#96BDFC")
const BUILDING: Color = Color("#414E91")
const BARRIER: Color = Color("#000000")


#const LANE_DIVIDER: Color = Color("#F0F0F0", 0.5)
#const JUNCTION_STOP: Color = Color("#CD0202", 0.8)
#const JUNCTION1: Color = Color("#CD0202", 0.7)
#const JUNCTION2: Color = Color("#CD0202", 0.6)
#const JUNCTION3: Color = Color("#CD0202", 0.5)
