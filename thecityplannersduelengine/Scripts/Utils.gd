extends Resource
class_name Utils
##Use this by calling Utils.function(), not global
#


static func divide_polygon_into_triangles(poly_verts: Array[Vector2]) -> Array[Vector2]:
	#from the poly vert find the biggest x and y and the smallest x and y, these define the search area of full cells
	#then using the width of each cell EngineData.GB_CELL_WIDTH generate all the vertexs (5 per cel, incuding thec enter vertex)
	#tehn for each vertex test if it is inside of the poly_verts, if so keep it if not remove it
	var w: float = EngineData.GB_CELL_WIDTH
	
	# --- 1. Get bounding box of polygon ---
	var min_x = poly_verts[0].x
	var max_x = poly_verts[0].x
	var min_y = poly_verts[0].y
	var max_y = poly_verts[0].y
	for v in poly_verts:
		min_x = min(min_x, v.x)
		max_x = max(max_x, v.x)
		min_y = min(min_y, v.y)
		max_y = max(max_y, v.y)
	
	# --- 2. Generate all candidate vertices per cell ---
	var inside_points: Array[Vector2] = []
	for x in range(floor(min_x / w), ceil(max_x / w)):
		for y in range(floor(min_y / w), ceil(max_y / w)):
			var x0 = x * w
			var y0 = y * w
			var cell_points = [
				Vector2(x0, y0),
				Vector2(x0 + w, y0),
				Vector2(x0, y0 + w),
				Vector2(x0 + w, y0 + w),
				Vector2(x0 + w / 2.0, y0 + w / 2.0)
			]
			
			# --- 3. Keep only points inside polygon ---
			for p in cell_points:
				if Geometry2D.is_point_in_polygon(p, poly_verts):
					inside_points.append(p)
	
	return inside_points
		
	



	
static func on_grid_corner_or_grid_center(point: Vector2) -> bool:
	if int(point.x) % EngineData.GB_CELL_WIDTH == 0 and int(point.y) % EngineData.GB_CELL_WIDTH == 0:
		return true #grid corner
	return false #grid center
		


	
	

	
	
static func get_custom_input_action_names() -> Array:
	#this returns a list of all the actions I specified in Project Settings -> Input Map 
	#wihtout all the default ones set by godot
	var all_actions = InputMap.get_actions()
	var custom_actions = []
	for action in all_actions:
		if not action.begins_with("ui_"): 
			custom_actions.append(action)
	return custom_actions
	
#static func event_to_string(ev: InputEvent) -> String:
	#match ev:
		#InputEventKey:
			#var txt := OS.get_keycode_string(ev.physical_keycode)
			#var mods := []
			#if ev.ctrl_pressed: mods.append("Ctrl")
			#if ev.alt_pressed: mods.append("Alt")
			#if ev.shift_pressed: mods.append("Shift")
			#if ev.meta_pressed: mods.append("Meta")
			#if mods.size() > 0:
				#return str(mods) + " + " + txt
			#return txt
#
		#InputEventMouseButton:
			#match ev.button_index:
				#MOUSE_BUTTON_LEFT:   return "Left Click"
				#MOUSE_BUTTON_RIGHT:  return "Right Click"
				#MOUSE_BUTTON_MIDDLE: return "Middle Click"
				#_:             return "Mouse Button %d" % ev.button_index
#
		#InputEventJoypadButton:
			#return "Joypad Button %d" % ev.button_index
#
		#_:
			#return str(ev)
