extends Camera2D

var move_speed: float = 500 #px/s
var zoom_speed: float = .05
var start_zoom: float = 1
var time_delta: float = 0

func _ready() -> void:
	zoom = Vector2.ONE * start_zoom

func _process(delta: float) -> void:
	time_delta = delta
	EngineData.mouse_position = get_global_mouse_position()
	EngineData.view_box = get_camera_view_box()
	print(EngineData.view_box)
	handle_move()
	handle_zoom()
	
func get_camera_view_box() -> Vector4:
	var c: float = position.x / EngineData.CELL_WIDTH_PX
	var r: float = position.y / EngineData.CELL_WIDTH_PX
	var view_size: Vector2 = get_camera_view_size(zoom)
	return Vector4(c, r, view_size.x, view_size.y)
	
func get_camera_view_size(at_zoom: Vector2) -> Vector2:
	return get_viewport_rect().size / at_zoom.x / EngineData.CELL_WIDTH_PX
		
func handle_move() -> void:
	var dir: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move camera north"):
		dir = Vector2(0, -1)
	if Input.is_action_pressed("move camera south"):
		dir = Vector2(0, +1)
	if Input.is_action_pressed("move camera west"):
		dir = Vector2(-1, 0)
	if Input.is_action_pressed("move camera east"):
		dir = Vector2(+1, 0)
	position += dir.normalized() * move_speed * time_delta * 1/zoom 
	
func handle_zoom() -> void:
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
	
	var new_zoom: float = zoom.x + dir * zoom_speed
	if new_zoom < max_zoom:
		new_zoom = max_zoom
	elif new_zoom > min_zoom:
		new_zoom = min_zoom
	zoom = Vector2.ONE * new_zoom
