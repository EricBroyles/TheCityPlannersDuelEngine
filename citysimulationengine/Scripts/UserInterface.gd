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
# draw speed(100) direction(ne) brush(10, 10)
# draw road junction1 speed(100) direction(any) brush(10,10)
# erase brush(10, 10) or draw erase brush(10,10)
# toggle background -> (hides or unhides background)
# toggle terrain_type -> 
# draw road brush -> default bursh is (10,10)
# draw speed -> warning: no (#) provided
# draw direction -> warning: no (str) provided
# draw road -> draws the road with 10,10 brush
# draw road brush -> same as draw road
# draw road brush(10,10) -> you get the idea.


@onready var world: World = %World
@onready var text_display: RichTextLabel = %TextDisplay
@onready var command_line: LineEdit = %CommandLine
@onready var brush: ColorRect = %Brush

var time_delta: float
var move_speed: float = 1000.0
var zoom_speed: float = 1.0
var move_dir: Vector2 = Vector2.ZERO
var zoom_dir: int = 0
var command_line_focus: bool = false
var draw_struct: DrawStruct = DrawStruct.create_empty()
var cmd_history: Array[String] = [] 
var cmd_history_idx: int = 0 

func _ready() -> void:
	close_brush()
	
func _process(delta: float) -> void:
	time_delta = delta
	handle_move()
	handle_zoom()
	unhandled_left_click()
	if brush.visible:
		update_brush_size()
		move_brush()
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("enter"): run_command(command_line.text)
	if Input.is_action_just_released("escape"): clear()
	if Input.is_action_just_released("up_arrow"): access_cmd_history(+1)
	if Input.is_action_just_released("down_arrow"): access_cmd_history(-1)

func _unhandled_input(_event: InputEvent) -> void:
	unhandled_move()

func clear() -> void:
	clear_command_line()
	close_brush()	
		
func run_command(cmd: String) -> void:
	var cmd_tokens: PackedStringArray = cmd.to_lower().strip_edges().split(" ")
	match cmd_tokens[0]:
		"draw": 
			open_brush(cmd_tokens.slice(1))
		"erase": 
			open_brush(cmd_tokens)
		"show": 
			match cmd_tokens[1]:
				"background": world.background.visible = true 
				"terrain_type": world.terrain_type.visible = true
				"terrain_mod": world.terrain_mod.visible = true
				"speed": world.speed_mph.visible = true 
				"speed_mph": world.speed_mph.visible = true 
				"direction": world.direction.visible = true
				"velocity": world.speed_mph.visible = true; world.direction.visible = true;
		"toggle":
			match cmd_tokens[1]:
				"background": world.background.visible = !world.background.visible 
				"terrain_type": world.terrain_type.visible = !world.terrain_type.visible 
				"terrain_mod": world.terrain_mod.visible = !world.terrain_mod.visible 
				"speed": world.speed_mph.visible = !world.speed_mph.visible 
				"speed_mph": world.speed_mph.visible = !world.speed_mph.visible #allow either speed or speedd_mph
				"direction": world.direction.visible = !world.direction.visible 
				"velocity": world.speed_mph.visible = !world.speed_mph.visible; world.direction.visible = !world.direction.visible ;
		"clear":
			match cmd_tokens[1]:
				"history": cmd_history = []; cmd_history_idx = 0;
		"help": pass
		"": pass
		_: push_error("USER INPUT ERROR: no matching command")
	cmd_history.push_front(command_line.text)
	clear_command_line()
	
func clear_command_line() -> void:
	command_line.text = ""
	command_line.release_focus()
	
func access_cmd_history(idx_delta: int) -> void:
	if not command_line_focus: return
	if cmd_history.size() == 0 : return
	if cmd_history_idx + idx_delta < 0: 
		command_line.text = ""
		cmd_history_idx = 0
	elif cmd_history_idx + idx_delta > cmd_history.size()-1:
		command_line.text = cmd_history[cmd_history.size()-1]
		cmd_history_idx = cmd_history.size()-1
	else:
		if idx_delta < 0: command_line.text = cmd_history[cmd_history_idx + idx_delta]
		else: command_line.text = cmd_history[cmd_history_idx]
		cmd_history_idx = cmd_history_idx + idx_delta
	
	
func open_brush(cmd_tokens: Array[String]) -> void:
	brush.visible = true
	draw_struct = DrawStruct.create(cmd_tokens)
	#if draw_struct.push_cmd != "": run_command(draw_struct.push_cmd)
	brush.size = draw_struct.get_px_size()
	brush.color = draw_struct.brush_color

func update_brush_size() -> void:
	# the brush size must increase when px_per_cell changes
	var old_size: Vector2i = Vector2i(brush.size)
	var new_size: Vector2i = draw_struct.get_px_size()
	if new_size == old_size: return
	brush.size = new_size
	
func move_brush() -> void:
	## FIX THIS NEED TO ACCOUNT FOR world-px somehow
	#var tl_pos: Vector2 = Vector2((GameData.mouse_screen_float_px - brush.size/2.0))
	#brush.position = world.get_grid_locked(tl_pos)
	
	var tl_pos: Vector2 = Vector2(round(GameData.mouse_screen_float_px - brush.size/2.0))
	brush.position = tl_pos

func close_brush() -> void:
	brush.visible = false
	draw_struct = DrawStruct.create_empty()

func unhandled_move() -> void:
	var new_move_dir: Vector2 = Vector2.ZERO
	if command_line_focus: move_dir = new_move_dir; return
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
		if draw_struct.type == DrawStruct.NONE: return
		var world_px: Vector2i = world.screen_px_to_px(Vector2i(brush.position))
		var world_cell_rect: Rect2i = Rect2i(world.get_cell_idx(world_px), draw_struct.brush_cell_size)
		match draw_struct.type:
			DrawStruct.ERASE: 
				world.erase(world_cell_rect) 
			DrawStruct.DRAW: 
				if not draw_struct.terrain_type_color.is_empty(): world.draw_terrain_type(world_cell_rect, draw_struct.terrain_type_color)
				if not draw_struct.terrain_mod_color.is_empty(): world.draw_terrain_mod(world_cell_rect, draw_struct.terrain_mod_color)
				if not draw_struct.speed_mph_color.is_empty(): world.draw_speed_mph(world_cell_rect, draw_struct.speed_mph_color)
				if not draw_struct.direction_color.is_empty(): world.draw_direction(world_cell_rect, draw_struct.direction_color)

func _on_command_line_focus_entered() -> void:
	command_line_focus = true
	close_brush()

func _on_command_line_focus_exited() -> void:
	command_line_focus = false



















	
	
	
