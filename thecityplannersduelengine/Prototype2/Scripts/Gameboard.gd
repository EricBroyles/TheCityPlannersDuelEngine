extends Node2D
class_name Gameboard

## Notes:
# Tile = 3x3 Cells

@onready var grid_tiles_sprite = %GridTilesSprite
@onready var grid_cells_sprite = %GridCellsSprite
@onready var terrain_mesh = %TerrainMesh
@onready var junction_sprites = %JunctionSprites
@onready var lane_dividers_mesh = %LaneDividersMesh
@onready var builder = %Builder


var tile_rows = 10
var tile_cols = 12

var matrix: Array[Array] #2D matrix of GameboardCells


# build the matrix
# show the tile map
#show the cell map


# On ready 
#1. build the matrix with Gameboard cells
#2. create two spprites called StaticTileGridSprite and StaticCellGridSprite, both just a black and white image of each tile or cell no extra information
#3. by default hide the CellGrid in godot editor

# gameboard builder, reads the inputs and creates the builder

# Builder Node2D -> Mesh and Sprite, one cell or 1 tile
# TerrainMesh MeshInstance2D
# Junctions Node2D: Draw Junction Sprites
# LaneDividersMesh MeshInstance2D

 
