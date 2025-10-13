extends Node

## Camera
var mouse_position: Vector2

#c,r: position in px converted to col/row as float
#size c,r: number of cells across and tall
var view_box: Vector4 

## Gameboard
const PX_PER_FT: int = 1
const CELL_WIDTH_FT: int = 4
const CELL_WIDTH_PX: int = CELL_WIDTH_FT * PX_PER_FT
const CHUNK_WIDTH_CELLS: int = 256

## Colors
var grid_dark_color: Color = Color("#3DD06E")
var grid_light_color: Color = Color("#4EF887")
var road_color: Color = Color("#78A2CE")
var walkway_color: Color = Color("#F4A361")
var parking_color: Color = Color("#2878CC")
var building_color: Color = Color("#BBBBBB")
var barrier_color: Color = Color("#424242")
var lane_divider_color: Color = Color("#F0F0F0", .5)
var stop_junction_color: Color = Color("#CD0202", .9)
var lvl1_junction_color: Color = Color("#CD0202", .7)
var lvl2_junction_color: Color = Color("#CD0202", .5)
var lvl3_junction_color: Color = Color("#CD0202", .3)
