#extends Node2D
##class_name GameboardPlacer
##
##@onready var placer_mesh: MeshInstance2D = %PlacerMesh
##
##enum OPTIONS {
	##NONE,
	##ROAD,
	##WALKWAY,
##}
##
##var active_option: int = OPTIONS.NONE
##
##func _process(delta: float) -> void:
	##if active_option != OPTIONS.NONE:
		##grid_locked_move(EngineData.mouse_position)
##
##func open(option: int) -> void:
	##close()
	##active_option = option
	##
	##pass
	##
##func close() -> void:
	##active_option = OPTIONS.NONE
	##clear_mesh()
	##
	##pass
	##
##func clear_mesh() -> void:
	##placer_mesh.rotation = 0
	##placer_mesh.mesh = ArrayMesh.new()
	##pass
##
##
##func draw_trisubcells_mesh(north: bool, south: bool, east: bool, west: bool, req_pos: Vector2, rotation_degrees: int) -> void:
	###
	###roation_degres must be in 90 degree intervals if not throw error
	##
	### if north is true and rotation degres is 90 then deactivate north and activate east, and so on.
	##
	###generate a 
	##pass
	##
	##
##
##func draw_cells_mesh(width: int, height: int, req_pos: Vector2, rotation_degrees: int) -> void:
	###this draws a rectnalge of size rect_size out of triangles
	###when considering what to define as size be sure to think of the rectangle with not rotation
	###rect_size: ex (.5, 1) 
	###imagine drawing a rectangle without any rotation for size
	###roation_degrees: rotation by 0, 45, 90, ...
	##
	###error handling: no width or heigh of 0, cannot rotate by increments of 45 degrees when cannot rotate with width of 1 and or height of 1, width and or ehight of 0 fails
	##
	###use this information 
	##
	##
	###integer number of triangles across
	##pass
	##
##func grid_locked_move(req_pos: Vector2, ) -> void:
	##pass
	##
##
###@onready var gameboard: Gameboard = %Gameboard
###@onready var mesh: MeshInstance2D = %PlacerMesh
###
###var orientation_degrees: int = 0
###var size_level_min: int = 0
###var size_level_max: int = 29
###var size_level: int = 0 
###var has_changed = false
###
###func _input(event: InputEvent) -> void:
	###
	###if event.is_action_released("remove from gameboard"):
		###has_changed = true
		###pass
	###if event.is_action_released("add to gameboard"):
		###has_changed = true
		###pass
	###if event.is_action_released("decrease"):
		####decrease the level
		###has_changed = true
		###pass
		###
	###if event.is_action_released("increase"):
		####increase the level 
		###
		###has_changed = true
		###pass
	###if event.is_action_released("rotate"):
		####tries to rotate 45 degrees if cant tehn rotate 90, rotating the PlacerMesh, need to redraw the mesh with the acutal shit for rotated
		#### if the orientation level is 0 rotate 90 otherwise roate by 45. 
		###has_changed = true
		###pass
		###
###func _process(delta: float) -> void:
	###position = EngineData.mouse_position
	###
	###if has_changed:
		###has_changed = false
		###pass
###
###func open() -> void:
	###
	####when it opens their will be a single triangle drawn 
	###pass
	###
###func close() -> void:
	###has_changed = false
	###size_level = 0
	###orientation_degrees = 0
	####remove everything from the mesh!!!!
	###
	###mesh.rotation = 0
	##
