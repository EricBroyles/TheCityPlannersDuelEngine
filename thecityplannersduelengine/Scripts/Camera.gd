extends Camera2D

var move_speed: float = 500 #px/sec
var zoom_speed: float = .025*2 
var start_zoom: float = .5
var zoom_out_limit: float = .02
var zoom_in_limit: float = 3

var movement_dirvec: Vector2 = Vector2.ZERO
var req_movement: Vector2 = Vector2.ZERO
var zoom_change: Vector2 = Vector2.ZERO
var req_zoom: Vector2 = Vector2.ZERO

func _ready() -> void:
	zoom = Vector2(start_zoom, start_zoom)
	
func _process(delta: float) -> void:
	EngineData.mouse_position = get_global_mouse_position()
	perform_move(delta)
	perform_zoom()
	
func perform_move(delta: float):
	movement_dirvec = Vector2.ZERO 
	if Input.is_action_pressed("move camera north"):
		movement_dirvec.y -= 1
	if Input.is_action_pressed("move camera south"):
		movement_dirvec.y += 1
	if Input.is_action_pressed("move camera west"):
		movement_dirvec.x -= 1
	if Input.is_action_pressed("move camera east"):
		movement_dirvec.x += 1
	req_movement = movement_dirvec.normalized() * move_speed * delta * 1/zoom 
	position += req_movement
	
func perform_zoom() -> void:
	zoom_change = Vector2.ZERO
	if Input.is_action_just_released("zoom camera in"):
		zoom_change = Vector2.ONE * zoom_speed 
	if Input.is_action_just_released("zoom camera out"):
		zoom_change = Vector2.ONE * -zoom_speed 
	if zoom_change != Vector2.ZERO:
		zoom_change += zoom
		zoom = Vector2(clamp(zoom_change.x, zoom_out_limit, zoom_in_limit), 
					   clamp(zoom_change.y, zoom_out_limit, zoom_in_limit))
	
	
