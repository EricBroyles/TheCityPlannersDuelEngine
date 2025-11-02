shader_type canvas_item;

//const uint int8max = 255u;
//const uint int32max = 4294967295u;

uniform int my_num;
uniform float conversion; //float so it has the size needed for the unsigned interger?
uniform sampler2D tex;

int decode(vec4 c) {
    return int(c.r * 255.0) << 24 |
           int(c.g * 255.0) << 16 |
           int(c.b * 255.0) << 8  |
           int(c.a * 255.0);
}


void fragment() {
	
	vec4 encoded_color = texture(tex, UV);
	vec4 color = vec4(1,0,0,1); //Red
	if (decode(encoded_color) == my_num) {
		color = vec4(0,0,0,1); //Black
	}
	COLOR = color;
	
	//vec4 encoded_color = texture(tex, UV);
	//vec4 color = vec4(1,0,0,1); //Red
	//if (int(round(encoded_color.x * conversion)) == my_num) {
		//color = vec4(0,0,0,1); //Black
	//}
	//
	//COLOR = color;
}