extends Node

class_name InputManager

func _input(event: InputEvent) -> void:
	
	if event.is_action_released("clear"):
		clear_state()
		
	
	if event.is_action_released("road"):
		clear_state()
		EngineData.input_state = EngineData.INPUT_STATES.ROAD 
		#close whatever other state was there
		#oppen the GameboardPlacer
		
	if event.is_action_released("walkway"):
		clear_state()
		EngineData.input_state = EngineData.INPUT_STATES.WALKWAY 
	
	
	
	
	if event.is_action_released("help"):
		print("--- Custom Input Actions ---")
		for action_name in Utils.get_custom_input_action_names():
			var events := InputMap.action_get_events(action_name)
			var event_texts: Array[String] = []
			for ev in events:
				event_texts.append(ev.as_text())
			print("%s --> %s" % [action_name, ", ".join(event_texts)])
		print("--- End of List ---")

	pass
	
	
func clear_state() -> void:
	EngineData.input_state = EngineData.INPUT_STATES.NONE
	



#func _process(delta: float) -> void:
	#print(EngineData.mouse_position)
#
#func _input(event: InputEvent) -> void:
	#handle_input(event)
#
	#
		#
#
#func handle_input(event: InputEvent) -> void: 
	#if event.is_action_released("help"): 
		#for action_name in Utils.get_custom_input_action_names(): 
			#print(action_name, " --> " , InputMap.action_get_events(action_name))
			#
	##if event.is_action_released("road"):
		#
			#
	#
#
	#
	#
	#
	##if Input.is_action_just_released("help"):
		##for action_name in InputMap.get_actions():
			##var events = InputMap.get_action_list(action_name)
			##var keys := []
			##for e in events:
				##if e is InputEventKey:
					##keys.append(OS.get_keycode_string(e.keycode))
				##else:
					##keys.append(str(e))
			##print(action_name, " -> ", keys)
	##elif Input.is_action_just_released("clear"): 
		##pass
		##
	##elif Input.is_action_just_released("increase"):
		##pass
