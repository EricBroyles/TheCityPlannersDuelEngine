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
const ROAD: Color = Color("#78A2CE")
const WALKWAY: Color = Color("#F4A361")
const CROSSWALK: Color = Color("#FFBC86")
const PARKING: Color = Color("#2878CC")
const BUILDING: Color = Color("#BBBBBB")
const BARRIER: Color = Color("#424242")
#const LANE_DIVIDER: Color = Color("#F0F0F0", 0.5)
#const JUNCTION_STOP: Color = Color("#CD0202", 0.8)
#const JUNCTION1: Color = Color("#CD0202", 0.7)
#const JUNCTION2: Color = Color("#CD0202", 0.6)
#const JUNCTION3: Color = Color("#CD0202", 0.5)
