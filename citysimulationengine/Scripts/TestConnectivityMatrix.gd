extends Node2D

#@onready var init_cm_sprite: Sprite2D = %InitialCM
#@onready var curr_cm_sprite: Sprite2D = %CurrentCM
@onready var subviewport: SubViewport = %SubViewport
@onready var process_cm: ColorRect = %ProcessCM



var dir_tex: ImageTexture
var cm0_tex: ImageTexture
var cm1_tex: ImageTexture

var init_cm0_img: Image #need this to show the very first cm0
var cm1_img: Image #need this so I have somthing to read pixels
var iteration: int = 0


# Tests:
# Size(10,10), Dir = All, Barrier = NONE -> should converge to all group_id = 0
# Size(10,10), DIR = NONE, Barrier = NONE -> should not change at all
# SIZE(10,10), DIR = ALL, BArrier = ALL -> should not change at all
# SIZE(10,10), DIR = ALL, BARRIER = split into 4 quadrents (one row and one col as barrier)-> expect 4 groups
# SIZE(10,10), DIR = N ONLY, BARRIER = NONE -> expect 10 vertical groups
# SIZE(10,10), DIR = S ONLY, BARRIER = NONE -> expect 10 vertical groups
# SIZE(10,10), DIR = E ONLY, BARRIER = split into 4 quadrents (one row and one col as barrier) -> expect 18 groups arrranged horizontally divided by quadrents
# LOOP: SIZE(10,10), DIR = LOOP using N,E,W,S BARRIER = center is barrier -> expect one group at outer edges
# TRAFFIC CIRCLE: SIZE(10,10), loop at the center and 4 roads connnecting -> expect one group representing the traffic circle. 
# Does it scale to 5000 x 5000


func _ready() -> void:
	# Test 1
	var size: Vector2i = Vector2i(10,10)
	var dir_option: String = "all"
	var barrier: bool = false
	fill_dir(size, "all")
	fill_cm0(size, barrier)


	# Needed for all Tests
	process_cm.material.set_shader_parameter("dir", dir_tex)
	process_cm.material.set_shader_parameter("size", cm0_tex.get_size())
	process_cm.material.set_shader_parameter("cm0", cm0_tex) # **** this needs to go here
	subviewport.size = size
	process_cm.size = size
	print_cm(init_cm0_img)
	
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("enter"):
		#await get_tree().process_frame  # <-- Wait for shader to render
		capture_cm1()
		print_cm(cm1_img)
		cm0_tex = cm1_tex
		process_cm.material.set_shader_parameter("cm0", cm0_tex) # *****1 this needs to go after to do it in the right num of iterations

"""
HELPERS
"""

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
	
func extract_px(color: Color) -> Vector3i:
	# Convert 0–1 floats into 8-bit ints
	var r: int = int(color.r * 255.0)
	var g: int = int(color.g * 255.0)
	var b: int = int(color.b * 255.0)
	var a: int = int(color.a * 255.0)
	
	# Reassemble the 32-bit packed integer
	var packed: int = (r << 24) | (g << 16) | (b << 8) | a
	
	# Remove the delta and barrier bits
	var idx_30bit: int = packed >> 2
	var delta: int = (packed >> 1) & 1
	var barrier: int = packed & 1
	return Vector3i(idx_30bit, delta, barrier)
	
func print_cm(cm: Image) -> void:
	var w: int = cm.get_width()
	var h: int = cm.get_height()
	
	print("------------")
	print("iteration: ", iteration)

	for r in h:
		var s: String = ""
		for c in w:
			var px_struct: Vector3i = extract_px(cm.get_pixel(c,r))
			var contents: String = (str(px_struct.x) + ", " + str(px_struct.z)).lpad(3)
			s += "(%s) " % [contents]
		print(s)
		
	iteration += 1
		
func capture_cm1() -> void:
	var cm1: Image = subviewport.get_viewport().get_texture().get_image()
	cm1_img = cm1
	cm1_tex = ImageTexture.create_from_image(cm1)

func fill_dir(size: Vector2i, dir_option: String) -> void:
	var dir: Image = Image.create_empty(size.x, size.y, false, DirectionColor.IMAGE_FORMAT)
	dir.fill(DirectionColor.string_create(dir_option).get_color())
	dir_tex = ImageTexture.create_from_image(dir)
	
func fill_cm0(size: Vector2i, barrier: bool) -> void:
	var cm0: Image = Image.create_empty(size.x, size.y, false, Image.FORMAT_RGBA8)
	var delta: bool = true
	for r in size.y:
		for c in size.x:
			var rowwise_idx: int = r * size.x + c     # r,c → rowwise index
			var clr: Color = pack_pixel(rowwise_idx,delta,barrier)
			cm0.set_pixel(c,r,clr)
	init_cm0_img = cm0
	cm0_tex = ImageTexture.create_from_image(cm0)
	
