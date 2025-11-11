#class_name CommandStruct
#
### USER INPUT: "component() component(int, int) component(string, int) component"
### get_tokens(cmd string): split at spaces & trim any extra spaces
### for token 
##  extract_component(): -> int | match the string component to the best COMPONENT
##  extract_group(): -> [] | 
#
### all comands must boil down to func(params, params, ...
## convert into a function name and function params
#
#
#grab each "component", clean it (remove spaces
#
### Eventually I have a list of function names and their params and I just fill that out and based on that I can call each of those.
#
#
#
## components: {COMPONENT_NAME: [], COMPONENT_NAME: ["int", "int"], COMPONENT_NAME: ["int", "int"],}
#
#enum COMPONENT {
	#
#}
#
#enum FUNC {
	#
#}
#
##this set of components -> function(params)
#
##object.callv("func_name", [param1, param2, ...])
#
### these represent the various functions that I can call
#var functions: Dictionary = {
	#"draw": []
	#
#}
#
#
#
#
#
#
#
#### Commands Input:
### "string seperated by spaces(with, groups, that, contain, any, value, string, int, etc)"
### "head body body(with, group) body"
##
#### Command Structure:
### Input -> Struct
### {"head": int, "body": [int, ...], "body_groups": [[], [int, string, ...], [int, int, ...]]}
##
#### Commands Smoother:
### Struct +> Interpreted Struct
### fills in missing information in the Struct.
##
#### Toggle
### toggle -> {"head": TOGGLE, "body": [], "body_groups": []}
###		 +> {"head": TOGGLE, "body": [], "body_groups": []}
### toggle  -> 
### toggle background terrain_type terrain_mod speed_mph direction -> {"head": TOGGLE, "body": [BACKGROUND, TERRAIN_TYPE, etc.], "body_group": [[], [], ...}
###																 +> {, body_groups: []}
##
#### Show
##
#### Hide
##
#### Clear
### history
##
#### Help
### all
##
##
#### Erase
##
##
#### Draw
### draw road brush(10,10) -> {"head": DRAW, "body": [ROAD, BRUSH], "body_groups": [[], [10, 10]]} (=A) 
###						 +> same
### road brush(10,10)      -> {"head": NONE, "body": [ROAD, BRUSH], "body_groups": [[], [10, 10]]}
###						 +> (A)
### road brush() 		     -> {"head": NONE, "body": [ROAD, BRUSH], "body_groups": [[], []]} (=B)
###						 +> (A)
### road brush 		     -> (B)
###						 +> (A)
### road 					 -> {"head": NONE, "body": [ROAD], "body_groups": [[]}
###						 +> (A)
##
##
#### I DONT WANT THIS TO HANDLE THE DEFAULT BRUSH SIZE, THAT IS DRAW STRUCT. 
##
##enum {NONE, INVALID}
##enum HEAD {TOGGLE, SHOW, HIDE, CLEAR, HELP, ERASE, DRAW}
##enum BODY {
	##ROAD, WALKWAY, CROSSWALK, PARKING, BUILDING, BARRIER, 
	##LANE_DIVIDER, JUNCTION_STOP, JUNCTION1, JUNCTION2, JUNCTION3,
	##SPEED_MPH, 
	##DIRECTION,
	##VELOCITY, BACKGROUND, TERRAIN_TYPE, TERRAIN_MOD, 
	##ALL, HISTORY, BRUSH
##}
##
#### Header Valid Body Options
##const TOGGLE_BODIES: Array[int] = [BODY.BACKGROUND, BODY.TERRAIN_TYPE, BODY.TERRAIN_MOD, BODY.SPEED_MPH, BODY.DIRECTION, BODY.VELOCITY]
##const SHOW_BODIES: Array[int] = TOGGLE_BODIES
##const HIDE_BODIES: Array[int] = TOGGLE_BODIES
##const CLEAR_BODIES: Array[int] = [BODY.HISTORY]
##const HELP_BODIES: Array[int] = [BODY.ALL]
##const ERASE_BODIES: Array[int] = [BODY.ALL, BODY.TERRAIN_TYPE, BODY.TERRAIN_MOD, BODY.SPEED_MPH, BODY.DIRECTION, BODY.BRUSH]
##const DRAW_BODIES: Array[int] = [
	##BODY.ROAD, BODY.WALKWAY, BODY.CROSSWALK, BODY.PARKING, BODY.BUILDING, BODY.BARRIER, BODY.LANE_DIVIDER, 
	##BODY.JUNCTION_STOP, BODY.JUNCTION1, BODY.JUNCTION2, BODY.JUNCTION3, BODY.SPEED_MPH, BODY.DIRECTION,
	##BODY.BRUSH
##]
##
##
##
##var cmd: String = ""
##var head: int = NONE
##var bodies: Array = []
##var bodies_group: Array = []
##
##static func create(given_cmd: String, do_smooth: bool = true) -> CommandStruct:
	##var struct: CommandStruct = CommandStruct.new()
	##struct.cmd = given_cmd
	##var cmd_tokens: PackedStringArray = given_cmd.to_lower().strip_edges().split(" ")
	##struct.set_head(cmd_tokens[0])
	##if struct.head != NONE: cmd_tokens = cmd_tokens.slice(1, cmd_tokens.size())
	##struct.set_bodies(cmd_tokens)
	##if not do_smooth: return struct
	##struct.smooth() 
	##return struct
	##
##func _to_string() -> String:
	##return "cmd_struct {head: " + str(head) + ", bodies: " + str(bodies) + ", bodies_group: " + str(bodies_group) + "}"
	##
##func smooth() -> void:
	### validates information, and fills in some missing information
	##
	##match head:
		##HEAD.TOGGLE: bodies_group = []; set_valid_bodies(TOGGLE_BODIES); if bodies.size() == 0: head = NONE;
		##HEAD.SHOW: bodies_group = []; set_valid_bodies(SHOW_BODIES); if bodies.size() == 0: head = NONE;
		##HEAD.HIDE: bodies_group = []; set_valid_bodies(HIDE_BODIES); if bodies.size() == 0: head = NONE;
		##HEAD.CLEAR: bodies_group = []; set_valid_bodies(CLEAR_BODIES); if bodies.size() == 0: head = NONE;
		##HEAD.HELP: bodies_group = []; set_valid_bodies(HELP_BODIES); if bodies.size() == 0: head = NONE;
		##HEAD.ERASE: set_valid_bodies(ERASE_BODIES); if bodies.size() == 0: bodies = [BODY.ALL];
		##HEAD.DRAW: set_valid_bodies(DRAW_BODIES); if bodies.size() == 0: head = NONE;
		##NONE:
			##set_valid_bodies(DRAW_BODIES)
			##if bodies.size() == 0 or (BODY.BRUSH in bodies and bodies.size() == 1): bodies = []; bodies_group = []
			##else: head = HEAD.DRAW
##
##func set_valid_bodies(all_valid_bodies: Array[int]) -> void:
	##var valid_bodies: Array[int] = []
	##for x in bodies:
		##if x in all_valid_bodies:
			##valid_bodies.append(x)
	##bodies = valid_bodies
	##
##func set_head(cmd_token: String) -> void:
	##match cmd_token:
		##"toggle": head = HEAD.TOGGLE
		##"show": head = HEAD.SHOW
		##"hide": head = HEAD.HIDE
		##"clear": head = HEAD.CLEAR
		##"help": head = HEAD.HELP
		##"erase": head = HEAD.ERASE
		##"draw": head = HEAD.DRAW
		##_: head = NONE
		##
##func set_bodies(cmd_tokens: PackedStringArray) -> void:
	##for cmd_token in cmd_tokens:
		##set_body(cmd_token)
		##
##func set_body(cmd_token: String) -> void:
	##var new_body: int = NONE
	##var new_body_group: Array = []
	##new_body_group = extract_group(cmd_token)
##
	##var body_length: int = cmd_token.find("(") #-1 if not found
	##if body_length == -1: body_length = cmd_token.length()
	##else: body_length -= 1 #to ignore the (
	##if body_length <= 0: return
	##var body_text: String = cmd_token.substr(0, body_length).strip_edges()
	##
	##match body_text:
		##"road": new_body = BODY.ROAD
		##"walkway": new_body = BODY.WALKWAY
		##"crosswalk": new_body = BODY.CROSSWALK
		##"parking": new_body = BODY.PARKING
		##"building": new_body = BODY.BUILDING
		##"barrier": new_body = BODY.BARRIER
		##"lane_divider": new_body = BODY.LANE_DIVIDER
		##"junction": new_body = BODY.JUNCTION_STOP
		##"junction_stop": new_body = BODY.JUNCTION_STOP
		##"junction1": new_body = BODY.JUNCTION1
		##"junction2": new_body = BODY.JUNCTION2
		##"junction3": new_body = BODY.JUNCTION3
		##"speed": new_body = BODY.SPEED_MPH
		##"speed_mph": new_body = BODY.SPEED_MPH
		##"direction": new_body = BODY.DIRECTION
		##"velocity": new_body = BODY.VELOCITY
		##"background": new_body = BODY.BACKGROUND
		##"terrain_type": new_body = BODY.TERRAIN_TYPE
		##"terrain": new_body = BODY.TERRAIN_TYPE
		##"terrain_mod": new_body = BODY.TERRAIN_MOD
		##"all": new_body = BODY.ALL
	##
	##if new_body == NONE: return
	##bodies.append(new_body)
	##bodies_group.append(new_body_group)
		##
##func extract_group(cmd_token: String) -> Array:
	### valid: group(int, int, string)
	### valid: group(int, int
	##
	##var group: Array = []
	##var group_start_idx: int = cmd_token.find("(") #-1 if not found
	##if group_start_idx == -1: return group
	##group_start_idx += 1 #to ignore the (
	##
	##var group_end_idx: int = cmd_token.find(")") #-1 if not found
	##if group_end_idx == -1: group_end_idx = cmd_token.length() #no ), so use full range
	##else: group_end_idx -= 1 #to ignore the )
	##
	##var group_length: int = group_end_idx - group_start_idx
	##if group_length <= 0: return group
	##
	##var group_parts: PackedStringArray = cmd_token.substr(group_start_idx, group_length).strip_edges().split(",")
	##for part in group_parts:
		##part.strip_edges()
		##if part.is_valid_int():
			##group.append(int(part))
		##else:
			##group.append(part) # keep as string
			##
	##return group
	##
##func get_draw_struct() -> DrawStruct:
	##var draw_struct: DrawStruct = DrawStruct.create_empty()
	##if   head == HEAD.DRAW : draw_struct.type = DrawStruct.DRAW
	##elif head == HEAD.ERASE: draw_struct.type = DrawStruct.ERASE
	##else: return draw_struct
	##
	##var brush_found: bool = false
##
	##for i in bodies.size():
		##match bodies[i]:
			##BODY.ROAD: draw_struct.terrain_type_color = TerrainTypeColor.create(TerrainTypeColor.ROAD)
			##BODY.WALKWAY: draw_struct.terrain_type_color = TerrainTypeColor.create(TerrainTypeColor.WALKWAY)
			##BODY.CROSSWALK: draw_struct.terrain_type_color = TerrainTypeColor.create(TerrainTypeColor.CROSSWALK)
			##BODY.PARKING: draw_struct.terrain_type_color = TerrainTypeColor.create(TerrainTypeColor.PARKING)
			##BODY.BUILDING: draw_struct.terrain_type_color = TerrainTypeColor.create(TerrainTypeColor.BUILDING)
			##BODY.BARRIER: draw_struct.terrain_type_color = TerrainTypeColor.create(TerrainTypeColor.BARRIER)
			##BODY.LANE_DIVIDER: draw_struct.terrain_mod_color = TerrainModColor.create(TerrainModColor.LANE_DIVIDER)
			##BODY.JUNCTION_STOP: draw_struct.terrain_mod_color = TerrainModColor.create(TerrainModColor.JUNCTION_STOP)
			##BODY.JUNCTION1: draw_struct.terrain_mod_color = TerrainModColor.create(TerrainModColor.JUNCTION1)
			##BODY.JUNCTION2: draw_struct.terrain_mod_color = TerrainModColor.create(TerrainModColor.JUNCTION2)
			##BODY.JUNCTION3: draw_struct.terrain_mod_color = TerrainModColor.create(TerrainModColor.JUNCTION3)
			##BODY.SPEED_MPH: 
				##var speed_mph: int = extract_speed_mph(i) #-1 if invalid
				##if speed_mph == -1: draw_struct.speed_mph_color = SpeedMPHColor.create_empty()
				##else: draw_struct.speed_mph_color = SpeedMPHColor.create(speed_mph)
			##BODY.DIRECTION: 
				##var direction: String = extract_direction(i) #"" if invalivd
				##if direction == "": draw_struct.direction_color = DirectionColor.create_empty()
				##else: draw_struct.direction_color = DirectionColor.string_create(direction)
			##CommandStruct.BODY.BRUSH: brush_found = true; draw_struct.brush_cell_size = extract_brush_size(i)
	##if not brush_found: draw_struct.brush_cell_size = DrawStruct.DEFAULT_BRUSH_SIZE
	##return draw_struct
	##
##func extract_speed_mph(idx: int) -> int:
	###find the speed in groups
	###returns -1, or integer (could be anythings specified by the user)
	###enrue the idx is valid for groups, then ensure the thing at that index is an arry of size greater than 0, if so ensure the item at index 0 is an integer.
	###if any of those fail return -1, just grab the integer and retunr it as is.
	##if idx < 0 or idx >= bodies_group.size(): return -1
	##var group: Array = bodies_group[idx]
	##if group.size() == 0: return -1 # Must have at least one argument
	##var first = group[0]
	##if not typeof(first) == TYPE_INT: return -1
	##return first
	##
##func extract_direction(idx: int) -> String:
	###finds the direction in groups
	###returns "" if non found, or "n", "ne, ...
	###same idea as extract speed, only difference is want a string instead of an integer. 
	##if idx < 0 or idx >= bodies_group.size(): return ""
	##var group: Array = bodies_group[idx]
	##if group.size() == 0: return ""
	##var first = group[0]
	##if not typeof(first) == TYPE_STRING: return ""
	##return first
	##
##func extract_brush_size(idx: int) -> Vector2i:
	###looks for a Array of [int, int] at the idx in groups
	###if none found it returns  DrawStruct.DEFAULT_BRUSH_SIZE as the size
	##if idx < 0 or idx >= bodies_group.size(): return DrawStruct.DEFAULT_BRUSH_SIZE
	##var group: Array = bodies_group[idx]
	##if group.size() == 0: return DrawStruct.DEFAULT_BRUSH_SIZE
	##elif group.size() == 1: return Vector2i(group[0], group[0])
	##else: return Vector2i(group[0], group[1])
