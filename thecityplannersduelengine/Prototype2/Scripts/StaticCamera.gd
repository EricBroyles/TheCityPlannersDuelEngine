extends Camera2D

## Static Camera: 
## Mouse_cell_position: the mouses position in terms of cells
## cells_view_rect: (c,r,w,h)
##		c: top_left_cell index
##		r:
##		w: number of cells allowed across the screen (

var move_speed: float = 500 #px/s
var zoom_speed: float = .05
var start_zoom: float = 1
var time_delta: float = 0

var continous_position: Vector2 = Vector2(0,0)
var continous_zoom: float = start_zoom

func _process(delta: float) -> void:
	time_delta = delta
	update_continous_position()
	update_continous_zoom()
	EngineData.mouse_cell_position = round(get_mouse_position() / EngineData.CELL_WIDTH_PX)
	
	EngineData.cells_view_rect = Utils.round_rect2(get_camera_view_rect())
	
	#print(EngineData.cells_view_rect)

func get_mouse_position() -> Vector2:
	var mouse_position_in_camera: Vector2 = get_global_mouse_position()
	return mouse_position_in_camera + continous_position 
	
func get_camera_view_rect() -> Rect2:
	return Rect2(continous_position / EngineData.CELL_WIDTH_PX, get_camera_view_size(continous_zoom))
	
func get_camera_view_size(at_zoom: float) -> Vector2:
	return get_viewport_rect().size / at_zoom / EngineData.CELL_WIDTH_PX
		
func update_continous_position() -> void:
	var dir: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move camera north"):
		dir = Vector2(0, -1)
	if Input.is_action_pressed("move camera south"):
		dir = Vector2(0, +1)
	if Input.is_action_pressed("move camera west"):
		dir = Vector2(-1, 0)
	if Input.is_action_pressed("move camera east"):
		dir = Vector2(+1, 0)
	continous_position += dir.normalized() * move_speed * time_delta * 1/zoom 
	
func update_continous_zoom() -> void:
	var dir: int = 0
	if Input.is_action_just_released("zoom camera in"):
		dir = +1
	if Input.is_action_just_released("zoom camera out"):
		dir = -1
	if dir == 0: return
	
	#find the max zoom (NOTE how max_zoom is different in x and y, we need the smallest for max)
	var max_zoom_vec: Vector2 = get_viewport_rect().size / EngineData.MAX_VIEW_BOX_WIDTH / EngineData.CELL_WIDTH_PX
	var max_zoom: float = min(max_zoom_vec.x, max_zoom_vec.y)
	
	#find the min zoom
	var min_zoom_vec: Vector2 = get_viewport_rect().size / EngineData.MIN_VIEW_BOX_WIDTH / EngineData.CELL_WIDTH_PX
	var min_zoom: float = max(min_zoom_vec.x, min_zoom_vec.y)
	
	var new_zoom: float = continous_zoom + dir * zoom_speed
	if new_zoom < max_zoom:
		new_zoom = max_zoom
	elif new_zoom > min_zoom:
		new_zoom = min_zoom
	continous_zoom = new_zoom
	#zoom = Vector2.ONE * continous_zoom
