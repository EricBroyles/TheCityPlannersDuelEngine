extends CanvasLayer
class_name UserInterface

#Input -> convert words to useful params that can be passed to a cmd
# TerrainTypeCOlor.string_create(string)

# keyword map from words to 
#draw ROAD JUNCTION1 250 NE ivec(10,10)  -> draw()
#use callv("cmd_draw", [parmams, ...]

## draw road junction1 mph(255) dir(ne) brush(10,10) or brush(10)

# cmd: String = funcname paramname(param_group) paramname(param_group) ...
# cmd_tokens: PackedStringArray = [funcname, paramname(param_group), paramname(param_group), ...]
# funcname: String = cmd_tokens[0]
# param_tokens: PackedStringArray = cmd_tokens[1:]
# param_token: String  = paramname(param_group)
# paramname: String = ...
# param_group: PackedStringArray  = [int, string, ...]



# map a "user input":"actual function name"
const FUNCNAMES_MAP: Dictionary = {
	"draw": "draw",
	"erase": "erase",
	"view": "view",
	"clear": "clear",
	"help": "help",
}

const ERROR: String = "__ERROR__"
const NaN: String = "none"
const INT: String = "int"
const STR: String = "string"
const V2i: String = "vector2i"
const TTC: String = "terrain_type_color"
const TMC: String = "terrain_mod_color"
const SMC: String = "speed_mph_color"
const DIC: String = "direction_color"
const BSH: String = "brush"


const ACTUAL_PARAMNAME: int = 0 #idx in map
const PARAMNAME_TYPE: int = 1 #idx in map
const GROUP_TYPE: int = 2 #idx in map

# "user_input": ["actual_paramname", "extract group as"]
const DRAW_PARAMS_MAP: Dictionary = {
	"road":          ["road",          TTC, NaN],
	"walkway":       ["walkway",       TTC, NaN],
	"crosswalk":     ["crosswalk",     TTC, NaN],
	"parking":       ["parking",       TTC, NaN],
	"building":      ["building", 	   TTC, NaN],
	"barrier":       ["barrier", 	   TTC, NaN],
	"lane_divider":  ["lane_divider",  TMC, NaN],
	"junction_stop": ["junction_stop", TMC, NaN],
	"junction1": 	 ["junction1", 	   TMC, NaN],
	"junction2": 	 ["junction2", 	   TMC, NaN],
	"junction3": 	 ["junction3",     TMC, NaN],
	"speed_mph": 	 ["speed_mph",     SMC, INT],
	"speed": 		 ["speed_mph",     SMC, INT],
	"mph": 			 ["speed_mph",     SMC, INT],
	"direction": 	 ["direction",     DIC, STR],
	"dir": 			 ["direction",     DIC, STR],
	"brush": 		 ["brush",         BSH, V2i],
}


const BRUSH_CSIZE: Vector2i = Vector2i(10,10)

func run_cmd(cmd: String) -> void:
	var cmd_tokens: PackedStringArray = cmd.to_lower().strip_edges().split(" ")
	
	var funcname: String = cmd_tokens[0].strip_edges()
	if FUNCNAMES_MAP.has(funcname): funcname = FUNCNAMES_MAP[funcname]
	else: push_warning("INPUT: [%s] PROBLEM: [%s] RESULT: [%s]" % [cmd, "no valid funcname", "cmd did not run"]); return;
	
	var get_params_funcname: String = "get_[%s]_params" % [funcname]
	var params_tokens: PackedStringArray = cmd_tokens.slice(1)
	var params: Array = call(get_params_funcname, params_tokens)
	
	if is_error(params): push_warning("INPUT: [%s] PROBLEM: [%s] RESULT: [%s]" % [cmd, params[1], "cmd did not run"]); return;
	callv(funcname, params)
	
func is_error(check_array: Array) -> bool:
	# checks to see if the first item in the array is ERROR
	if check_array[0] == ERROR: return true
	return false
	
func make_error(problem_description: String = "") -> Array[String]:
	# [ERROR, "problem description"]
	return [ERROR, problem_description]
	
func get_draw_params(params_tokens: PackedStringArray) -> Array:
	# returns [ERROR, "problem", "result"] if invalid
	
	var ttc: TerrainTypeColor = TerrainTypeColor.create_empty()
	var tmc: TerrainModColor = TerrainModColor.create_empty()
	var smc: SpeedMPHColor = SpeedMPHColor.create_empty()
	var dic: DirectionColor = DirectionColor.create_empty()
	var bsh: Vector2i = BRUSH_CSIZE
	
	for param_token in params_tokens:
		var paramname: String = extract_paramname(param_token)
		if DRAW_PARAMS_MAP.has(paramname): paramname = DRAW_PARAMS_MAP[paramname][ACTUAL_PARAMNAME]
		else: return make_error("no matching paramnames in DRAW_PARAMS_MAP [%s]" % [paramname])
		
		"extract_terrain_type_color"
		match DRAW_PARAMS_MAP[paramname][PARAMNAME_TYPE]:
			TTC: ttc = call("extract_[%s]" % [TTC], paramname)
			TMC: tmc = call("extract_[%s]" % [TMC], paramname)
			SMC: smc = call("extract_[%s]" % [SMC], extract_param_group(param_token)) 
			DIC: dic = call("extract_[%s]" % [DIC], extract_param_group(param_token))
			BSH: bsh = call("extract_[%s]" % [BSH], extract_param_group(param_token)) 
			
	return [ttc,tmc,smc,dic,bsh]
	
func extract_terrain_type_color(paramname: String) -> TerrainTypeColor:
	# paramname: "road" "walkway" "crosswalk" "parking" "building" "barrier"
	return TerrainTypeColor.string_create(paramname)

func extract_terrain_mod_color(paramname: String) -> TerrainModColor:
	#paramname: "lane_divider" "junction_stop" "junction1" "junction2" "junction3"
	return TerrainModColor.string_create(paramname)
	
func extract_speed_mph_color(param_group: PackedStringArray) -> SpeedMPHColor:
	#param_group: ["int"]
	return SpeedMPHColor.create(param_group[0].to_int())
	
func extract_direction_color(param_group: PackedStringArray) -> DirectionColor:
	# param_group: ["ne"]
	return DirectionColor.string_create(param_group[0])
	
func extract_brush(param_group: PackedStringArray) -> Vector2i:
	# param_group: ["int", "int"] or ["int"] or []
	# returns BRUSH_CSIZE if [] of [int, int, int, ...]
	if param_group.size() == 2: return Vector2i(param_group[0].to_int(), param_group[1].to_int())
	if param_group.size() == 1: return Vector2i.ONE * param_group[0].to_int()
	return BRUSH_CSIZE
	
func extract_paramname(param_token: String) -> String:
	# Does not verify the paramname
	# param_token: brush(10,10) or road or road( or somthing()
	return param_token.substr(0, param_token.find("("))
	
func extract_param_group(param_token: String) -> PackedStringArray:
	# Does not verify the group and leaves as strings
	# split based on ","
	# ex: brush(10,10) -> ["10", "10"], brush -> [], bursh( -> [], brush(10,10 -> ["10", "10"]
	var param_group: PackedStringArray = []
	var start_idx: int = param_token.find("(")
	if start_idx == -1: return param_group
	start_idx += 1
	var end_idx: int = param_token.find(")")
	if end_idx != -1: end_idx += 1 
	var inside: String = param_token.substr(start_idx, end_idx).strip_edges()
	for p in inside.split(",", false): param_group.append(p.strip_edges())
	return param_group
	
	
	
	

	

	
	
	
	

func cmd_draw(tt: TerrainTypeColor, tm: TerrainModColor, mph: SpeedMPHColor, dir: DirectionColor, brush_csize: Vector2i = BRUSH_CSIZE) -> void:
	## NEXT.
	pass
	
func cmd_erase(brush_csize: Vector2i = BRUSH_CSIZE) -> void:
	pass
	
func cmd_view(options: Array[int]) -> void:
	pass
	
func cdm_clear(options: Array[int]) -> void:
	pass
	
func cmd_help() -> void:
	pass


## Shortcuts
# W A S D -> move the view  (unhandled)
# scroll wheel -> zoom the view  
# enter -> run command line
# escape -> clear the user interface
# left click -> draw stuff on the screen (unhandled)

# 1. User Input: head() body() body(int, String, int, bool) body(int) body 
# 2. Convert to Standard form:  {HEAD: [], BODY: [], BODY: ["int, String, int"], BODY: [int], BODY: []}
# then for each type of body convert its group into a more useful item Vectro2i, etc.
# no sommthing or interpretation, just 
# change toggle, show, hide, to view(t/f) ...
# get rid of Draw Struct and COmmand Struct
# must always have a head, if NONE put it as NONE.
# do not seperate HEAD and BODY enum, as this can result in weird cross over behavior as 0 in HEAD matches 0 in BODY



#@onready var world: World = %World
#@onready var text_display: RichTextLabel = %TextDisplay
#@onready var command_line: LineEdit = %CommandLine
#@onready var brush: ColorRect = %Brush
#
#var time_delta: float
#var move_speed: float = 1000.0
#var zoom_speed: float = 1.0
#var move_dir: Vector2 = Vector2.ZERO
#var zoom_dir: int = 0
#var command_line_focus: bool = false
#var cmd_history: Array[String] = [] 
#var cmd_history_idx: int = 0 
#var draw_struct: DrawStruct = DrawStruct.create_empty()
#
#enum {
	#NONE, VIEW, CLEAR, HELP, ERASE, DRAW, 
	#ROAD, WALKWAY, CROSSWALK, PARKING, BUILDING, BARRIER, 
	#LANE_DIVIDER, JUNCTION_STOP, JUNCTION1, JUNCTION2, JUNCTION3,
	#SPEED_MPH, 
	#DIRECTION,
	#VELOCITY, BACKGROUND, TERRAIN_TYPE, TERRAIN_MOD, 
	#ALL, HISTORY, BRUSH
#}
##var command: Dictionary = {"HEAD": NONE} 
#
#func _ready() -> void:
	#close_brush()
	#
#func _process(delta: float) -> void:
	#time_delta = delta
	#handle_move(); handle_zoom()
	#unhandled_left_click()
	#if brush.visible: update_brush_size(); move_brush()
	#
#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_released("enter"): run_command(command_line.text)
	#if Input.is_action_just_released("escape"): clear()
	#if Input.is_action_just_released("up_arrow"): access_cmd_history(+1)
	#if Input.is_action_just_released("down_arrow"): access_cmd_history(-1)
#
#func _unhandled_input(_event: InputEvent) -> void:
	#unhandled_move()
#
#func clear() -> void:
	#clear_command_line()
	#close_brush()
	#
#func open_brush() -> void: 
	#brush.visible = true
	#draw_struct = cmd_struct.get
	#brush.size = draw_struct.get_px_size()
	#brush.color = draw_struct.brush_color
#
#func update_brush_size() -> void:
	## the brush size must increase when px_per_cell changes
	#var old_size: Vector2i = Vector2i(brush.size)
	#var new_size: Vector2i = draw_struct.get_px_size()
	#if new_size == old_size: return
	#brush.size = new_size
	#
#func move_brush() -> void:
	### FIX THIS NEED TO ACCOUNT FOR world-px somehow
	##var tl_pos: Vector2 = Vector2((GameData.mouse_screen_float_px - brush.size/2.0))
	##brush.position = world.get_grid_locked(tl_pos)
	#
	#var tl_pos: Vector2 = Vector2(round(GameData.mouse_screen_float_px - brush.size/2.0))
	#brush.position = tl_pos
#
#func close_brush() -> void:
	#brush.visible = false
	#draw_struct = DrawStruct.create_empty()
#
#func unhandled_move() -> void:
	#var new_move_dir: Vector2 = Vector2.ZERO
	#if command_line_focus: move_dir = new_move_dir; return
	#if Input.is_action_pressed("w"): new_move_dir += Vector2(+0, -1)
	#if Input.is_action_pressed("a"): new_move_dir += Vector2(-1, +0)
	#if Input.is_action_pressed("s"): new_move_dir += Vector2(+0, +1)
	#if Input.is_action_pressed("d"): new_move_dir += Vector2(+1, +0)
	#move_dir = new_move_dir
#
#func handle_move() -> void:
	#world.move_view(Vector2i(round(move_dir.normalized() * move_speed * time_delta)))
#
#func handle_zoom() -> void:
	#var dir: int = 0
	#if Input.is_action_just_released("scroll_in"):  dir = +1
	#elif Input.is_action_just_released("scroll_out"): dir = -1
	#if dir == 0: return
	#world.zoom_view(int(dir * zoom_speed))
	#
#func unhandled_left_click() -> void:
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#if draw_struct.type == DrawStruct.NONE: return
		#var world_px: Vector2i = world.screen_px_to_px(Vector2i(brush.position))
		#var world_cell_rect: Rect2i = Rect2i(world.get_cell_idx(world_px), draw_struct.brush_cell_size)
		#match draw_struct.type:
			#DrawStruct.ERASE: 
				#world.erase(world_cell_rect) 
			#DrawStruct.DRAW: 
				#if not draw_struct.terrain_type_color.is_empty(): world.draw_terrain_type(world_cell_rect, draw_struct.terrain_type_color)
				#if not draw_struct.terrain_mod_color.is_empty(): world.draw_terrain_mod(world_cell_rect, draw_struct.terrain_mod_color)
				#if not draw_struct.speed_mph_color.is_empty(): world.draw_speed_mph(world_cell_rect, draw_struct.speed_mph_color)
				#if not draw_struct.direction_color.is_empty(): world.draw_direction(world_cell_rect, draw_struct.direction_color)
#
#func _on_command_line_focus_entered() -> void:
	#command_line_focus = true
	#close_brush()
#
#func _on_command_line_focus_exited() -> void:
	#command_line_focus = false
	#
		#
#func run_command(cmd: String) -> void:
	#
	#
	##print("ehllo")
	##var cmd_struct: CommandStruct = CommandStruct.create(cmd)
	### resolve the cmd_struct 
	##print(cmd_struct)
	##match cmd_struct.head:
		##CommandStruct.HEAD.TOGGLE: print("toggle"); cmd_toggle(cmd_struct)
		##CommandStruct.HEAD.SHOW: cmd_show(cmd_struct)
		##CommandStruct.HEAD.HIDE: cmd_hide(cmd_struct)
		##CommandStruct.HEAD.CLEAR: cmd_clear(cmd_struct)
		##CommandStruct.HEAD.HELP: cmd_help(cmd_struct)
		##CommandStruct.HEAD.ERASE: cmd_erase(cmd_struct)
		##CommandStruct.HEAD.DRAW: cmd_draw(cmd_struct)
		##CommandStruct.NONE: push_warning("USER INPUT: failed to run command [" + cmd + "] with cmd_struct " + cmd_struct.to_string())
		##_: push_warning("USER INPUT: failed to run command [" + cmd + "] with cmd_struct " + cmd_struct.to_string())
	##
	## reset 
	#cmd_history.push_front(command_line.text)
	#clear_command_line()
	#
#func clear_command_line() -> void:
	#command_line.text = ""
	#command_line.release_focus()
	#
#func access_cmd_history(idx_delta: int) -> void:
	#if not command_line_focus: return
	#if cmd_history.size() == 0 : return
	#if cmd_history_idx + idx_delta < 0: 
		#command_line.text = ""
		#cmd_history_idx = 0
	#elif cmd_history_idx + idx_delta > cmd_history.size()-1:
		#command_line.text = cmd_history[cmd_history.size()-1]
		#cmd_history_idx = cmd_history.size()-1
	#else:
		#if idx_delta < 0: command_line.text = cmd_history[cmd_history_idx + idx_delta]
		#else: command_line.text = cmd_history[cmd_history_idx]
		#cmd_history_idx = cmd_history_idx + idx_delta
	
	






### Command Resolutions
#func cmd_toggle(cmd_struct: CommandStruct) -> void:
	#match cmd_struct.bodies:
		#CommandStruct.BODY.BACKGROUND: world.background.visible =  !world.background.visible
		#CommandStruct.BODY.TERRAIN_TYPE: world.terrain_type.visible = !world.terrain_type.visible
		#CommandStruct.BODY.TERRAIN_MOD: world.terrain_mod.visible = !world.terrain_mod.visible
		#CommandStruct.BODY.SPEED_MPH: world.speed_mph.visible = !world.speed_mph.visible
		#CommandStruct.BODY.DIRECTION: world.direction.visible = !world.direction.visible
		#CommandStruct.BODY.VELOCITY: world.speed_mph.visible = !world.speed_mph.visible; world.direction.visible = !world.direction.visible
#
#func cmd_show(cmd_struct: CommandStruct) -> void:
	#match cmd_struct.bodies:
		#CommandStruct.BODY.BACKGROUND: world.background.visible = true
		#CommandStruct.BODY.TERRAIN_TYPE: world.terrain_type.visible = true
		#CommandStruct.BODY.TERRAIN_MOD: world.terrain_mod.visible = true
		#CommandStruct.BODY.SPEED_MPH: world.speed_mph.visible = true
		#CommandStruct.BODY.DIRECTION: world.direction.visible = true
		#CommandStruct.BODY.VELOCITY: world.speed_mph.visible = true; world.direction.visible = true
	#
#func cmd_hide(cmd_struct: CommandStruct) -> void:
	#match cmd_struct.bodies:
		#CommandStruct.BODY.BACKGROUND: world.background.visible = false
		#CommandStruct.BODY.TERRAIN_TYPE: world.terrain_type.visible = false
		#CommandStruct.BODY.TERRAIN_MOD: world.terrain_mod.visible = false
		#CommandStruct.BODY.SPEED_MPH: world.speed_mph.visible = false
		#CommandStruct.BODY.DIRECTION: world.direction.visible = false
		#CommandStruct.BODY.VELOCITY: world.speed_mph.visible = false; world.direction.visible = false
	#
#func cmd_clear(cmd_struct: CommandStruct) -> void:
	#match cmd_struct.bodies:
		#CommandStruct.BODY.HISTORY: cmd_history = []; cmd_history_idx = 0;
#
#func cmd_help(cmd_struct: CommandStruct) -> void:
	#match cmd_struct.bodies:
		#CommandStruct.BODY.ALL: print("I figured it out.")
#
#func cmd_erase(cmd_struct: CommandStruct) -> void:
	#open_brush(cmd_struct)
	#
#func cmd_draw(cmd_struct: CommandStruct) -> void:
	#print("hello", cmd_struct.bodies, cmd_struct.bodies_group)
	#open_brush(cmd_struct)














	
	
	
