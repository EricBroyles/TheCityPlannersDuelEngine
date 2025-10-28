shader_type canvas_item;

//const uint int8max = 255u;
//const uint int32max = 4294967295u;

uniform int my_num;
uniform float conversion; //float so it has the size needed for the unsigned interger?
uniform sampler2D tex;

void fragment() {
	
	vec4 encoded_color = texture(tex, UV);
	vec4 color = vec4(1,0,0,1); //Red
	if (int(round(encoded_color.x * conversion)) == my_num) {
		color = vec4(0,0,0,1); //Black
	}
	
	COLOR = color;
}