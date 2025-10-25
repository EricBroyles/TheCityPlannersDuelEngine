extends Node2D
#class_name GameboardBuilder
#
#@onready var gb: Gameboard = %Gameboard 
#@onready var mesh_instance: MeshInstance2D = %MeshInstance
#
###THIS IS NOT GOING TO WORK DUE TO HOW I AM HANDLING POSITION, THE POSITION DOES NOT REALLY CHANGE
#
#
#
#var MIN_CELL_SIZE: Vector2i = Vector2i.ONE
#var MAX_CELL_SIZE: Vector2i = MIN_CELL_SIZE * 50
#var cell_size: Vector2i = MIN_CELL_SIZE
#var cell: GameboardCell = GameboardCell.create_empty()
#
#func _process(delta: float) -> void:
	#if cell.is_empty(): return
	#move_builder()
		#
#func open_with(c: GameboardCell) -> void:
	#close()
	#cell = c
	#draw_builder()
	#
#func close() -> void:
	#cell_size = MIN_CELL_SIZE
	#cell = GameboardCell.create_empty()
	#mesh_instance.mesh = ArrayMesh.new()
#
#func increment(by: int) -> void:
	#cell_size = clamp(cell_size + Vector2i.ONE * by, MIN_CELL_SIZE, MAX_CELL_SIZE)
	#draw_builder()
	#
#func gameboard_add() -> void:
	#var rect_region: Rect2 = Rect2(self.position, cell_size * GameData.gb_px_per_cell)
	#gb.add_cell_at_rect_region(cell, rect_region)
	#
#func gameboard_remove() -> void:
	#var rect_region: Rect2 = Rect2(self.position, cell_size * GameData.gb_px_per_cell)
	#gb.remove_cell_at_rect_region(cell, rect_region)
	#
#func move_builder() -> void:
	#var req_center_pos: Vector2 = GameData.mouse_position
	#var px_per_cell: int = GameData.gb_px_per_cell
	#var builder_size: Vector2 = cell_size * px_per_cell
	#var tl_pos: Vector2 = req_center_pos - (builder_size)/2
	#var grid_tl_pos: Vector2i = Vector2i(tl_pos / px_per_cell) * px_per_cell
	#self.position = grid_tl_pos 
	#
#func draw_builder() -> void:
	#mesh_instance.mesh = get_array_mesh()
#
#func get_array_mesh() -> ArrayMesh:
	#var mesh: ArrayMesh = ArrayMesh.new()
	#var cell_color: Color = cell.get_color()
	#var px_per_cell: int = GameData.gb_px_per_cell
	#var size: Vector2i = cell_size * px_per_cell 
	#var vertices = PackedVector2Array([
		#Vector2(0, 0),
		#Vector2(size.x, 0),
		#Vector2(size.x, size.y),
		#Vector2(0, size.y)
	#])
	#var colors = PackedColorArray([
		#cell_color, cell_color, cell_color, cell_color
	#])
	#var indices = PackedInt32Array([0, 1, 2, 0, 2, 3])
	#var arrays: Array = []
	#arrays.resize(Mesh.ARRAY_MAX)
	#arrays[Mesh.ARRAY_VERTEX] = vertices
	#arrays[Mesh.ARRAY_COLOR] = colors
	#arrays[Mesh.ARRAY_INDEX] = indices
	#mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	#return mesh
