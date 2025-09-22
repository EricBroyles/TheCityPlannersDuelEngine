class_name Utils
##Use this by calling Utils.function(), not global

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
