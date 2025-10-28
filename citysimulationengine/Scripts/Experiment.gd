extends Node2D

# GOAL: take a integer of some size and encode it into an image and then on the gpu extract that encoded value exactly.
#hypothesis: the color stored in a rgba8 and accessed by sampler2D will be 8 bit per channel
#hypothesis: the color stored in a rgbaf and accessed by sampler2D will be 32 bit per channel

# I want to write data at 3 size levels 
# lvl 1: 0 -> 255 (8 bit)
# lvl 2: 0 -> 65504 (16 bit signed)
# lvl 3: 0 -> 16 777 216 (use for ids) (32 bit unsigned)

# Discovery:
# Format_RGBA8 write 0 -> 255 successfully, the img px are 8 bit unsigned 
# Format_RGBA32 write -2140000000 (exactly this, why?) -> 2 147 483 647 successfully, the img px are 32 bit signed
#		SAFE TO DO 0 -> 16 777 216 (THIS IS PLENTY)
#2000000000
#2147483647

#RGBA8	4	8-bit	Unsigned	Exact 0–255 values, great for manual bit-packing
#RGBAH	4	16-bit	Signed float	Not suitable for integers beyond ±65504
#RGBAF	4	32-bit	Signed float	Precise up to ±16,777,216, after that it loses integer precision

const UNSIGNED_INT8_MAX : float = 255
const UNSIGNED_INT32_MAX: float = 2147483647 #4294967295
var rgba8_img: Image = Image.create(1,1,false,Image.FORMAT_RGBA8) #each channel has bit depth of 8
var rgba32_img: Image = Image.create(1,1,false,Image.FORMAT_RGBAF) #each channel has 32 bit floating point
var my_num: int = -2140000000

@onready var text_rect: TextureRect = %TextureRect

func _ready() -> void:
	var rgba8_encoded_num: float = my_num / UNSIGNED_INT8_MAX
	var rgba32_encoded_num: float = my_num / UNSIGNED_INT32_MAX
	var rgba8_color: Color = Color(rgba8_encoded_num,0,0,0)
	var rgba32_color: Color = Color(rgba32_encoded_num,0,0,0)
	rgba8_img.fill(rgba8_color)
	rgba32_img.fill(rgba32_color)
	var tex8: ImageTexture = ImageTexture.create_from_image(rgba8_img)
	var tex32: ImageTexture = ImageTexture.create_from_image(rgba32_img)
	
	print("my_num: ", my_num, " | rgba8_encoded_num: ", rgba8_encoded_num, " | rgba8_color: ", rgba8_color)
	print("my_num: ", my_num, " | rgba32_encoded_num: ", rgba32_encoded_num, " | rgba32_color: ", rgba32_color)
	
	text_rect.material.set_shader_parameter("my_num", my_num)
	#text_rect.material.set_shader_parameter("conversion", UNSIGNED_INT8_MAX)
	#text_rect.material.set_shader_parameter("tex", tex8)
	
	text_rect.material.set_shader_parameter("conversion", UNSIGNED_INT32_MAX)
	text_rect.material.set_shader_parameter("tex", tex32)
	

#packs the 32 bit int into RGBA8 format (8bit, 8bit, 8bit, 8bit)
func pack_uint_to_color(value: int) -> Color:
	var r = float(value & 0xFF) / 255.0
	var g = float((value >> 8) & 0xFF) / 255.0
	var b = float((value >> 16) & 0xFF) / 255.0
	var a = float((value >> 24) & 0xFF) / 255.0
	return Color(r, g, b, a)
	
# get a way to 
	
	
