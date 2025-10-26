extends CanvasLayer
@onready var world: World = %World
@onready var text_display: RichTextLabel = %TextDisplay
@onready var command_line: LineEdit = %CommandLine
@onready var rect_brush: ColorRect = %RectBrush

## Shortcuts
# W A S D -> move the view  (unhandled)
# scroll wheel -> zoom the view  (unhandled)
# enter -> run command line
# escape -> clear the user interface
# left click -> draw stuff on the screen (unhandled)

## Command Structure
# Branch: SubBranch: Command1 Command2 ...
# all lower case

## Commands:
# help:
# text:
# show:
# hide:
# draw: road: rect_brush(10,12)
# draw: walkway:  (defaults to rect_brush(1,1))
#		junction1 2 3 junction_stop, barrier, lane_divider, building
# draw: velocity100ne: rect_brush(10,12)
# erase: rect_brush(10, 12)
 
##
# need to build a view_position -> world coordinates


var dark_transparent_color: Color = Color(0,0,0,.5)
var time_delta: float
var move_speed: float = 1000.0
var zoom_speed: float = 1.0

func _ready() -> void:
	close_rect_brush()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("enter"):
		run_command(command_line.text)
		clear_command_line()
	if Input.is_action_just_released("escape"):
		reset()

func _unhandled_input(_event: InputEvent) -> void:
	handle_move()
	handle_zoom()
	if Input.is_action_just_released("left_click"):
		pass
	
func _process(delta: float) -> void:
	time_delta = delta
	if rect_brush.visible:
		move_rect_brush()

func reset() -> void:
	clear_command_line()
	close_rect_brush()
	
func run_command(cmd: String) -> void:
	var tokens: Array[String] = cmd.to_lower().strip_edges().split(" ")
	match tokens[0]:
		"draw":
			if tokens[1].contains("velocity"):
				# strip out the speed and direction.
				#just do transparetn
				pass
			match tokens[1]:
				"road": pass
				"walkway": pass
				"barrier": pass
				"lane_divider": pass
				"junction_stop": pass
				"junction1": pass
				"junction2": pass
				"junction3": pass
				"building": pass
				"parking": pass
		"erase":
			pass
		"help":
			pass
		_: print("No match for command.")
	

	
func clear_command_line() -> void:
	command_line.text = ""
	command_line.release_focus()
	
func move_rect_brush() -> void:
	pass

func open_rect_brush(color: Color, size: Vector2) -> void:
	rect_brush.color = color
	rect_brush.size = size
	
func close_rect_brush() -> void:
	rect_brush.visible = false

func handle_move() -> void:
	var dir: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("w"): dir += Vector2(+0, -1)
	if Input.is_action_pressed("a"): dir += Vector2(-1, +0)
	if Input.is_action_pressed("s"): dir += Vector2(+0, +1)
	if Input.is_action_pressed("d"): dir += Vector2(+1, +0)
	if dir == Vector2.ZERO: return
	world.move_view(Vector2i(round(dir.normalized() * move_speed * time_delta)))

func handle_zoom() -> void:
	var dir: int = 0
	if Input.is_action_just_released("scroll_in"):  dir = +1
	elif Input.is_action_just_released("scroll_out"): dir = -1
	if dir == 0: return
	world.zoom_view(int(dir * zoom_speed))
	
