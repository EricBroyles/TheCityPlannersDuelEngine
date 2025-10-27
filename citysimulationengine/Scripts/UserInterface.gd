extends CanvasLayer
class_name UserInterface

## Shortcuts
# W A S D -> move the view  (unhandled)
# scroll wheel -> zoom the view  
# enter -> run command line
# escape -> clear the user interface
# left click -> draw stuff on the screen (unhandled)

## Commands
# draw road brush(10, 10)  --- must have draw first | exact spacing does not matter 
# draw velocity(100, ne) brush(10, 10)
# erase brush(10, 10) or draw erase brush(10,10)

@onready var world: World = %World
@onready var text_display: RichTextLabel = %TextDisplay
@onready var command_line: LineEdit = %CommandLine
@onready var brush: ColorRect = %Brush

var time_delta: float
var move_speed: float = 1000.0
var zoom_speed: float = 1.0

var move_dir: Vector2 = Vector2.ZERO
var zoom_dir: int = 0

var draw_struct: DrawStruct = DrawStruct.create_empty()

func _ready() -> void:
	close_brush()
	
func _process(delta: float) -> void:
	time_delta = delta
	handle_move()
	handle_zoom()
	if brush.visible:
		update_brush_size()
		move_brush()
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("enter"): run_command()
	if Input.is_action_just_released("escape"): clear()

func _unhandled_input(_event: InputEvent) -> void:
	unhandled_move()
	unhandled_left_click()

func clear() -> void:
	clear_command_line()
	close_brush()	
		
func run_command() -> void:
	var cmd_tokens: PackedStringArray = command_line.text.to_lower().strip_edges().split(" ")
	match cmd_tokens[0]:
		"draw": 
			open_brush(cmd_tokens.slice(1))
		"erase": 
			open_brush(cmd_tokens)
		"help": pass
		"": pass
		_: push_error("USER INPUT ERROR: no matching command")
	clear_command_line()
	
func clear_command_line() -> void:
	command_line.text = ""
	command_line.release_focus()

func open_brush(cmd_tokens: Array[String]) -> void:
	print("here")
	brush.visible = true
	draw_struct = DrawStruct.create(cmd_tokens)
	brush.size = draw_struct.get_px_size()
	brush.color = draw_struct.brush_color

func update_brush_size() -> void:
	# the brush size must increase when px_per_cell changes
	var old_size: Vector2i = Vector2i(brush.size)
	var new_size: Vector2i = draw_struct.get_px_size()
	if new_size == old_size: return
	brush.size = new_size
	
func move_brush() -> void:
	## FIX THIS
	var tl_pos: Vector2 = Vector2((GameData.mouse_screen_float_px - brush.size/2.0))
	brush.position = world.get_grid_locked(tl_pos)
	
	#var tl_pos: Vector2 = Vector2(round(GameData.mouse_screen_float_px - brush.size/2.0))
	#brush.position = tl_pos

func close_brush() -> void:
	print("he")
	brush.visible = false
	draw_struct = DrawStruct.create_empty()

func unhandled_move() -> void:
	var new_move_dir: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("w"): new_move_dir += Vector2(+0, -1)
	if Input.is_action_pressed("a"): new_move_dir += Vector2(-1, +0)
	if Input.is_action_pressed("s"): new_move_dir += Vector2(+0, +1)
	if Input.is_action_pressed("d"): new_move_dir += Vector2(+1, +0)
	move_dir = new_move_dir

func handle_move() -> void:
	world.move_view(Vector2i(round(move_dir.normalized() * move_speed * time_delta)))

func handle_zoom() -> void:
	var dir: int = 0
	if Input.is_action_just_released("scroll_in"):  dir = +1
	elif Input.is_action_just_released("scroll_out"): dir = -1
	if dir == 0: return
	world.zoom_view(int(dir * zoom_speed))
	
func unhandled_left_click() -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if draw_struct.draw_type == DrawStruct.DRAW_TYPE.NONE: return
		var world_px: Vector2i = world.screen_px_to_px(Vector2i(brush.position))
		var world_cell_rect: Rect2i = Rect2i(world.get_cell_idx(world_px), draw_struct.brush_cell_size)
		match draw_struct.draw_type:
			DrawStruct.DRAW_TYPE.ERASE: world.erase(world_cell_rect)
			DrawStruct.DRAW_TYPE.TERRAIN: world.draw_terrain(world_cell_rect, draw_struct.terrain_color.color)
			DrawStruct.DRAW_TYPE.VELOCITY: world.draw_velocity(world_cell_rect, draw_struct.velocity_color.color)

func _on_command_line_focus_entered() -> void:
	close_brush()
























### Shortcuts
## W A S D -> move the view  (unhandled)
## scroll wheel -> zoom the view  (unhandled)
## enter -> run command line
## escape -> clear the user interface
## left click -> draw stuff on the screen (unhandled)
#
### Commands:
## help:
## text:
## show:
## hide:
## draw: road: rect_brush(10,12)
## draw: walkway:  (defaults to rect_brush(1,1))
##		junction1 2 3 junction_stop, barrier, lane_divider, building
## draw: velocity100ne: rect_brush(10,12)
## erase: rect_brush(10, 12)
#
#const MIN_BRUSH_SIZE: Vector2i = Vector2i.ONE
#const MAX_BRUSH_SIZE: Vector2i = MIN_BRUSH_SIZE * 50
#const BRUSH_COLOR: Color = Color(0,0,0,.5)
#const EMPTY_CELL_COLOR: Color = Color(0,0,0,0)
#
#var time_delta: float
#var move_speed: float = 2000.0
#var zoom_speed: float = 1.0
#
#var brush_cell_size: Vector2i = MIN_BRUSH_SIZE
#var brush_color: Color = BRUSH_COLOR
#
#
#var cell_draw_color: Color = Color(0,0,0,0)
#
#
#func _ready() -> void:
	#close_rect_brush()
#
#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_released("enter"):
		#run_command(command_line.text)
		#clear_command_line()
	#if Input.is_action_just_released("escape"):
		#reset()
#
#func _unhandled_input(_event: InputEvent) -> void:
	#handle_move()
	#handle_zoom()
	#if Input.is_action_just_released("left_click"):
		#pass
	#
#func _process(delta: float) -> void:
	#time_delta = delta
	#if rect_brush.visible: 
		#update_rect_brush_size()
		#move_rect_brush()
#
#func reset() -> void:
	#clear_command_line()
	#close_rect_brush()
	#
#func run_command(cmd: String) -> void:
	#var tokens: Array[String] = cmd.to_lower().strip_edges().split(" ")
	#match tokens[0]:
		#"draw":
			#if tokens[1].contains("velocity"):
				## strip out the speed and direction.
				##just do transparetn
				#pass
			#var cell_size: Vector2i = Vector2i(1,1) if tokens.size() < 2 else Vector2i(string_to_vector2(tokens[2]))
			#open_rect_brush(brush_color, cell_size)
			#match tokens[1]:
				#"road": cell_draw_color = TerrainColor.ROAD
				#"walkway": cell_draw_color = TerrainColor.WALKWAY
				#"barrier": cell_draw_color = TerrainColor.BARRIER
				#"lane_divider": cell_draw_color = TerrainColor.LANE_DIVIDER
				#"junction_stop": cell_draw_color = TerrainColor.JUNCTION_STOP
				#"junction1": cell_draw_color = TerrainColor.JUNCTION1
				#"junction2": cell_draw_color = TerrainColor.JUNCTION2
				#"junction3": cell_draw_color = TerrainColor.JUNCTION3
				#"building": cell_draw_color = TerrainColor.BUILDING
				#"parking": cell_draw_color = TerrainColor.PARKING
		#"erase":
			#pass
		#"help":
			#pass
		#_: push_error("USER INPUT ERROR: no matching command")
	#
#
	#
#func clear_command_line() -> void:
	#command_line.text = ""
	#command_line.release_focus()
	#
#func move_rect_brush() -> void:
	#pass
#
#func open_rect_brush(color: Color, cell_size: Vector2i) -> void:
	#brush_cell_size = cell_size
	#rect_brush.color = color
	#rect_brush.size = brush_cell_size * GameData.world_px_per_cell
	#
#func update_rect_brush_size() -> void:
	#var old_size: Vector2i = Vector2i(rect_brush.size)
	#var new_size: Vector2i = brush_cell_size * GameData.world_px_per_cell
	#if new_size == old_size: return
	#rect_brush.size = new_size
	#
#func close_rect_brush() -> void:
	#brush_cell_size = Vector2i.ONE
	#rect_brush.visible = false
#
#func handle_move() -> void:
	#var dir: Vector2 = Vector2.ZERO
	#if Input.is_action_pressed("w"): dir += Vector2(+0, -1)
	#if Input.is_action_pressed("a"): dir += Vector2(-1, +0)
	#if Input.is_action_pressed("s"): dir += Vector2(+0, +1)
	#if Input.is_action_pressed("d"): dir += Vector2(+1, +0)
	#if dir == Vector2.ZERO: return
	#world.move_view(Vector2i(round(dir.normalized() * move_speed * time_delta)))
#
#func handle_zoom() -> void:
	#var dir: int = 0
	#if Input.is_action_just_released("scroll_in"):  dir = +1
	#elif Input.is_action_just_released("scroll_out"): dir = -1
	#if dir == 0: return
	#world.zoom_view(int(dir * zoom_speed))
	#
#func string_to_vector2(s: String) -> Vector2:
	##v(number, number)
	#s = s.strip_edges().replace("(", "").replace(")", "").replace(" ", "")
#
	#var parts = s.split(",")
	#if parts.size() != 2:
		#push_error("USER INPUT ERROR: string_to_vector2: Invalid format: '%s'" % s)
		#return Vector2.ZERO
#
	#return Vector2(parts[0].to_float(), parts[1].to_float())
	
	
	
