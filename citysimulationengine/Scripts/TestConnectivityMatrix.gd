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
# (PASS) Size(10,10), Dir = All, Barrier = NONE -> should converge to all group_id = 0 
# (PASS) Size(10,10), DIR = NONE, Barrier = NONE -> should not change at all 
# (PASS) SIZE(10,10), DIR = ALL, BArrier = ALL -> should not change at all
# (PASS) SIZE(10,10), DIR = ALL, BARRIER = split into 4 quadrents (one row and one col as barrier)-> expect 4 groups
# (PASS) SIZE(10,10), DIR = N ONLY, BARRIER = NONE -> expect 10 vertical groups
# (PASS) SIZE(10,10), DIR = S ONLY, BARRIER = NONE -> expect 10 vertical groups

# SIZE(10,10), DIR = E ONLY, BARRIER = split into 4 quadrents (one row and one col as barrier) -> expect 18 groups arrranged horizontally divided by quadrents
# LOOP: SIZE(10,10), DIR = LOOP using N,E,W,S BARRIER = center is barrier -> expect one group at outer edges
# TRAFFIC CIRCLE: SIZE(10,10), loop at the center and 4 roads connnecting -> expect one group representing the traffic circle. 
# Does it scale to 5000 x 5000


func _ready() -> void:
	## (PASS) Test 1: Expect all group_id = 0
	#var size: Vector2i = Vector2i(10,10)
	#var dir_option: String = "all"
	#var barrier: bool = false
	#fill_dir(size, dir_option)
	#fill_cm0(size, barrier)
	
	## (PASS) Test 2: Expect no change
	#var size: Vector2i = Vector2i(10,10)
	#var dir_option: String = "none"
	#var barrier: bool = false
	#fill_dir(size, dir_option)
	#fill_cm0(size, barrier)
	#
	## (PASS) Test 3: Expect no change
	#var size: Vector2i = Vector2i(10,10)
	#var dir_option: String = "all"
	#var barrier: bool = true
	#fill_dir(size, dir_option)
	#fill_cm0(size, barrier)
	
	## (PASS) Test 4: Expect 4 groups in each corner sperated by barriers
	#var size: Vector2i = Vector2i(10,10)
	#var dir_option: String = "all"
	#var dividers_col: Array[int] = [4]
	#var dividers_row: Array[int] = [5]
	#fill_dir(size, dir_option)
	#fill_cm0_with_dividers(size, dividers_col, dividers_row)
	
	## (PASS) Test 5: Expect 10 vertical groups
	#var size: Vector2i = Vector2i(10,10)
	#var dir_option: String = "n"
	#var multi_dir: bool = false
	#var barrier: bool = false
	#fill_dir(size, dir_option, multi_dir)
	#fill_cm0(size, barrier)
	
	## (PASS) Test 6: Expect 10 vertical groups
	#var size: Vector2i = Vector2i(10,10)
	#var dir_option: String = "s"
	#var multi_dir: bool = false
	#var barrier: bool = false
	#fill_dir(size, dir_option, multi_dir)
	#fill_cm0(size, barrier)
	
	## (PASS) Test 7: Expect 10 horizontal groups
	#var size: Vector2i = Vector2i(10,10)
	#var dir_option: String = "e"
	#var multi_dir: bool = false
	#var barrier: bool = false
	#fill_dir(size, dir_option, multi_dir)
	#fill_cm0(size, barrier)
	
	## (PASS) Test 8: Expect 10 horizontal groups
	#var size: Vector2i = Vector2i(10,10)
	#var dir_option: String = "w"
	#var multi_dir: bool = false
	#var barrier: bool = false
	#fill_dir(size, dir_option, multi_dir)
	#fill_cm0(size, barrier)
	
	## () Test 9: 1 + 2(L-1) diagonal groups where L is the Lenght of the square (so 19 for L = 10)
	var size: Vector2i = Vector2i(10,10)
	var dir_option: String = "nw"
	var multi_dir: bool = false
	var barrier: bool = false
	fill_dir(size, dir_option, multi_dir)
	fill_cm0(size, barrier)
	
	#try it with ne, and nw, se, sw
	
	
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

func fill_dir(size: Vector2i, dir_option: String, multi_dir = true) -> void:
	var dir: Image = Image.create_empty(size.x, size.y, false, DirectionColor.IMAGE_FORMAT)
	dir.fill(DirectionColor.string_create(dir_option, multi_dir).get_color())
	dir_tex = ImageTexture.create_from_image(dir)
	
func _simple_fill_cm0(size: Vector2i, delta: bool, barrier: bool) -> Image:
	var cm0: Image = Image.create_empty(size.x, size.y, false, Image.FORMAT_RGBA8)
	for r in size.y:
		for c in size.x:
			var rowwise_idx: int = r * size.x + c     # r,c → rowwise index
			var clr: Color = pack_pixel(rowwise_idx,delta,barrier)
			cm0.set_pixel(c,r,clr)
	return cm0
	
func fill_cm0(size: Vector2i, barrier: bool) -> void:
	var delta: bool = true
	var cm0: Image = _simple_fill_cm0(size, delta, barrier)
	init_cm0_img = cm0
	cm0_tex = ImageTexture.create_from_image(cm0)
	
func fill_cm0_with_dividers(size: Vector2i, dividers_col: Array[int], dividers_row: Array[int]) -> void:
	## WARNING: this has all barriers not have a normal rowwise idx, instead they use 0 as their idx.
	## 			this should not be a problem as the idx for anything labeled as barrier does not matter
	
	var cm0: Image = _simple_fill_cm0(size, true, false)
	var delta: bool = true
	for col_idx in dividers_col:
		var x: int = col_idx; var y: int = 0
		var w: int = 1;       var h: int = size.y
		cm0.fill_rect(Rect2i(x,y,w,h), pack_pixel(0, true, true))
		
	for row_idx in dividers_row:
		var y: int = row_idx; var x: int = 0
		var h: int = 1;       var w: int = size.x
		cm0.fill_rect(Rect2i(x,y,w,h), pack_pixel(0, true, true))
		
	init_cm0_img = cm0
	cm0_tex = ImageTexture.create_from_image(cm0)
	
