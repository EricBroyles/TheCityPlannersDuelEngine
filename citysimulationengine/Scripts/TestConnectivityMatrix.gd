extends Node2D

@onready var init_cm_sprite: Sprite2D = %InitialCM
@onready var curr_cm_sprite: Sprite2D = %CurrentCM
@onready var subviewport: SubViewport = %SubViewport
@onready var process_cm: ColorRect = %ProcessCM

var dir: Image
var dir_tex: ImageTexture
var init_cm: Image
var init_cm_tex: ImageTexture
var cm1: Image

func _ready() -> void:
	init_test1()
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("enter"):
		# take a screenshot
		cm1 = subviewport.get_viewport().get_texture().get_image()
		print(init_cm.get_size())
		print(cm1.get_size()) #thse should be the same
		for r in init_cm.get_height():
			for c in init_cm.get_width():
				print("cm0: ", init_cm.get_pixel(c,r) * 255.0, " | cm1: ", cm1.get_pixel(c,r) * 255.0)
		
	elif Input.is_action_just_pressed("escape"):
		# send information to shader again
		process_cm.material.set_shader_parameter("dir", ImageTexture.create_from_image(dir))
		process_cm.material.set_shader_parameter("cm0", ImageTexture.create_from_image(init_cm))
		process_cm.material.set_shader_parameter("size", init_cm.get_size())
		

		

	
func init_test1() -> void:
	"""
	GOAL: Can I pack data and send to cm and then get it back and send it again
	DIR = ALL
	INIT_CM: DELTA = TRUE & BARRIER = FALSE
	SIZE: 10x10
	"""
	var size: Vector2i = Vector2i(10,10)
	subviewport.size = size
	process_cm.size = size
	
	dir = Image.create_empty(size.x, size.y, false, Image.FORMAT_R8)
	dir.fill(DirectionColor.string_create("all").get_color())
	dir_tex = ImageTexture.create_from_image(dir)
	
	init_cm = Image.create_empty(size.x, size.y, false, Image.FORMAT_RGBA8)
	
	var delta: bool = true
	var barrier: bool = false
	for r in size.y:
		for c in size.x:
			var rowwise_idx: int = r * size.x + c     # r,c → rowwise index
			var clr: Color = pack_pixel(rowwise_idx,delta,barrier)
			print(rowwise_idx, " ", clr * 255.0)
			init_cm.set_pixel(c,r,clr)
	
	init_cm_tex = ImageTexture.create_from_image(init_cm)
			
	init_cm_sprite.texture = init_cm_tex
	init_cm_sprite.scale = Vector2(100,100)
	
	process_cm.material.set_shader_parameter("dir", ImageTexture.create_from_image(dir))
	process_cm.material.set_shader_parameter("cm0", ImageTexture.create_from_image(init_cm))
	process_cm.material.set_shader_parameter("size", init_cm.get_size())
			

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
	










#"""
#NOTES TO SELF:
#COLOR RECTS have a size and there for are easier than sprites which need some texture default to give it a size.
#Set the background of the SubViewport to transparent "Transparent BG" to avoid blending grey witch my drawn colors when screen shoting
#
#with color of shader as (.9,.9,.9,.5) -> (114.0, 114.0, 114.0, 127.0) even with setting to transparent bg
#
#I think I need to flip the texture?
#
#BE SURE TO SET render_mode blend_disabled; for the shader or it will blend the alpha and require me to do a bunch more work.
#
#"""
#
### NOTE TO SELF NEED TO HAVE A DEFAULT TEXTURE IN THE SPRITES even if that texture is empty
#
#@onready var init_cm_sprite: Sprite2D = %InitialCM
##@onready var curr_cm: Sprite2D = %CurrentCM
#@onready var subviewport: SubViewport = %SubViewport
#@onready var process_cm: ColorRect = %ProcessCM
#
## need to create various dir matrix and various cm starting layouts
#
## track all the results
#
#const SIZE: Vector2i = Vector2i(512,512)
#
#var dir: Image
#var init_cm: Image
#var cm1: Image
#var did_draw = false
#
#
#func _ready() -> void:
	### Tests
	#init_test1()
	#
	#
#
	#
	#
#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("enter"):
		### please not I have change the subcviewport size to 10,10
		#process_cm.material.set_shader_parameter("dir", ImageTexture.create_from_image(dir))
		#process_cm.material.set_shader_parameter("cm0", ImageTexture.create_from_image(init_cm))
		#process_cm.material.set_shader_parameter("size", init_cm.get_size())
		#
		#cm1 = subviewport.get_viewport().get_texture().get_image() # in theory this forces a sync, and finishes when the gpu is done drawing.
		## the image blends the color with the alpha, unblend by dividing rgb by alpha on 0->1
		##cm1.flip_y()
		#
		### MAKE SURE TO
		### WARNING I THINK THAT IT IS GETTING THE BLENDED COLOR. try and unblend the background, or get rid of the backgroun
		#
		#for r in init_cm.get_height():
			#for c in init_cm.get_width():
				#print("cm0: ", init_cm.get_pixel(c,r) * 255.0, " | cm1: ", cm1.get_pixel(c,r) * 255.0)
		#
#
		### WARNING EVERY ITERATION I NEED TO SCREEN SHOT IT to update the cm0
		### press a different key to screen shot
		##when do i get teh screen shot the process_cm????????????????? 
		#did_draw = true
#
##func _draw() -> void:
	##if do_draw
	#
#
#"""
#Test1
#subviewport is 10 x 10
#CM0: 10 x 10
#[
	#[(rowwise_idx = 0, delta = false, barrier = false), (rowwise_idx = 1, delta = false, barrier = false), ... , (rowwise_idx = 9, delta = false, barrier = false)]
	#[(rowwise_idx = 10, delta = false, barrier = false), (rowwise_idx = 11, delta = false, barrier = false), ... , (rowwise_idx = 19, delta = false, barrier = false)]
	#...
	#[(rowwise_idx = 90, delta = false, barrier = false), (rowwise_idx = 1, delta = false, barrier = false), ... , (rowwise_idx = 99, delta = false, barrier = false)]
#]
#
#CM0 Colors
#[
	#[(0.0, 0.0, 0.0, 0.0), (0.0, 0.0, 0.0, 4.0), ... , (0.0, 0.0, 0.0, 36.0)]
	#...
	#[(0.0, 0.0, 1.0, 104.0), (0.0, 0.0, 1.0, 108.0), ... , (0.0, 0.0, 1.0, 140.0)]
#]
#
#After one iteration I expect the top corner (2x2) to all be 0s
#"""
