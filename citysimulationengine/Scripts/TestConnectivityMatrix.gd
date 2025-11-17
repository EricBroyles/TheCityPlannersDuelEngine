extends Node2D

@onready var init_cm_sprite: Sprite2D = %InitialCM
#@onready var curr_cm: Sprite2D = %CurrentCM
@onready var subviewport: SubViewport = %SubViewport
@onready var process_cm: Sprite2D = %ProcessCM

# need to create various dir matrix and various cm starting layouts

# track all the results

const SIZE: Vector2i = Vector2i(512,512)

var dir: Image
var init_cm: Image
var cm1: Image
var did_draw = false


func _ready() -> void:
	## Tests
	init_test1()
	
	
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("enter"):
		## please not I have change the subcviewport size to 10,10
		process_cm.material.set_shader_parameter("dir", dir)
		process_cm.material.set_shader_parameter("cm0", init_cm)
		process_cm.material.set_shader_parameter("size", init_cm.get_size())
		
		cm1 = subviewport.get_viewport().get_texture().get_image() # in theory this forces a sync, and finishes when the gpu is done drawing.
		
		for r in init_cm.get_height():
			for c in init_cm.get_width():
				print("cm0: ", init_cm.get_pixel(c,r) * 255.0, " | cm1: ", cm1.get_pixel(c,r) * 255.0)
		

		## WARNING EVERY ITERATION I NEED TO SCREEN SHOT IT to update the cm0
		## press a different key to screen shot
		#when do i get teh screen shot the process_cm????????????????? 
		did_draw = true

#func _draw() -> void:
	#if do_draw
	



func init_test1() -> void:
	# goal to test the packing of (30bit = rowwise) 
	# dir == all
	# initial cm will have no barriers
	var size: Vector2i = Vector2i(10,10)
	dir = Image.create_empty(size.x, size.y, false, Image.FORMAT_R8)
	init_cm = Image.create_empty(size.x, size.y, false, Image.FORMAT_RGBA8)
	
	dir.fill(DirectionColor.string_create("all").get_color())
	
	var delta: bool = false
	var barrier: bool = false
	for r in size.y:
		for c in size.x:
			var rowwise_idx: int = r * size.x + c     # r,c → rowwise index
			var clr: Color = pack_pixel(rowwise_idx,delta,barrier)
			print(rowwise_idx, " ", clr * 255.0)
			init_cm.set_pixel(c,r,clr)
			
			
	init_cm_sprite.texture = ImageTexture.create_from_image(init_cm)
	init_cm_sprite.scale = Vector2(100,100)
			

func pack_pixel(idx: int, delta: bool, barrier: bool) -> Color:
	var idx_30bit: int = (idx & 0x3FFFFFFF) << 2 #should be the same as idx unless number is too large to be specified by 30 bit
	var packed: int = idx_30bit | (int(delta) << 1) | int(barrier)
	
	# Extract 8 bits per channel
	var r: int = (packed >> 24) & 0xFF
	var g: int = (packed >> 16) & 0xFF
	var b: int = (packed >> 8) & 0xFF
	var a: int = packed & 0xFF

	# Convert to 0–1 range for Color
	return Color(r / 255.0, g / 255.0, b / 255.0, a / 255.0)
