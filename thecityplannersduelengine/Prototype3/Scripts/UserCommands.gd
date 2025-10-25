extends Node
class_name UserCommands

@onready var command_line: LineEdit = %CommandLine
@onready var top_text_data: RichTextLabel = %TopTextData
@onready var input_tips: RichTextLabel = %InputTips


#

# Commands
#    ro wa j1 etc.

## Create a list of commands
# Build Cell: stats
#augment the size of the builder

# take the input, splice the input, match the input handle the output
# this will take the command line input and splice it to determine the velocity and terrain desired fro a cell to be built/remove
#this will handle inputs to increa the size of the builder/decrease

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ENTER):
		handle_command_line_request()
		
func handle_command_line_request() -> void:
	var s: String = command_line.text
	command_line.text = ""
	command_line.release_focus()
	var tokens: PackedStringArray = s.strip_edges().split(" ")
	

#static func string_to_contents(s: String) -> Array[bool]:
	#var tokens: PackedStringArray = s.strip_edges().split(" ")
	#var result: Array[bool] = get_empty_contents()
	#for token in tokens:
		#if not token.begins_with("ve"):  
			#match token:
				#"ro": result[ROAD] = true
				#"wa": result[WALKWAY] = true
				#"bu": result[BUILDING] = true
				#"pa": result[PARKING] = true
				#"ba": result[BARRIER] = true
				#"la": result[LANE_DIVIDER] = true
				#"js": result[STOP_JUNCTION] = true
				#"j1": result[LVL1_JUNCTION] = true
				#"j2": result[LVL2_JUNCTION] = true
				#"j3": result[LVL3_JUNCTION] = true
				#_: push_warning("Unknown terrain code: ", token)
	#return result
	#
#static func string_to_velocity(s: String) -> Velocity:
	#var v: Velocity = Velocity.create_empty()
	#if s.strip_edges() == "": return v
	#var tokens: PackedStringArray = s.strip_edges().split(" ")
	#for token in tokens:
		#if token.begins_with("ve"):
			## Extract numeric and direction parts
			## Example: "Ve30NE" -> speed = 30, dir = "NE"
			#var body = token.substr(2, token.length() - 2)
			#var speed_str: String = ""
			#var dir_str: String = ""
			## Separate digits and letters
			#for c in body:
				#if c.is_valid_int():
					#speed_str += c
				#else:
					#dir_str += c
			#if speed_str != "":
				#v.speed_mph = float(speed_str)
			#if dir_str != "":
				#v.set_direction_degrees_from_cardinal(dir_str)
	#return v
	

#func _input(_event: InputEvent) -> void:
	#
	#if Input.is_key_pressed(KEY_ENTER):
		#cell.override(
			#GameboardCell.string_to_contents(text_input.text),
			#GameboardCell.string_to_velocity(text_input.text)
		#)
		#clear_text_input()
		#draw_builder()
	#
#func _unhandled_input(_event: InputEvent) -> void:
#
	#if Input.is_key_pressed(KEY_TAB):
		#increment(1)
		#draw_builder()
	#
	#elif Input.is_key_pressed(KEY_BACKSPACE):
		#increment(-1)
		#draw_builder()
		#
	#elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		#gameboard_add()
		#
	#elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#gameboard_remove()
	#
	#elif Input.is_key_pressed(KEY_ESCAPE):
		#clear()
