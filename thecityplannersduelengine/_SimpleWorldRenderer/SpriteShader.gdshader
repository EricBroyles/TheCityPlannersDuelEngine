shader_type canvas_item;
render_mode unshaded;

uniform sampler2D tex;
uniform int scale;

void fragment() {
	vec2 texture_size = vec2(textureSize(tex, 0)); //0 is just mipmap lvl
	//vec2 uv_scaled = floor(UV * texture_size / float(scale)) * float(scale) / texture_size;
	vec4 color = texture(tex, UV);
	COLOR = color;
}


//
//uniform sampler2D tex;
////uniform vec2 position;
//uniform int scale; 
//uniform float speed : hint_range(0, 5.0) = 1.0; // speed of color flux
//
////void vertex() {
    ////VERTEX = position;
////}
//
//void fragment() {

    //// Calculate scaled UVs
    //vec2 tex_size = vec2(textureSize(tex, 0)); // texture dimensions in pixels
    //vec2 uv_scaled = floor(UV * tex_size / float(scale)) * float(scale) / tex_size;
    //
    //// Sample the texture at scaled UV
    //vec4 color = texture(tex, uv_scaled);
//
    //// Time-based color modulation
    ////float t = TIME * speed;
    ////color.r += 0.2 * sin(t + UV.x * 5.0);
    ////color.g += 0.2 * sin(t + UV.y * 5.0);
    ////color.b += 0.2 * sin(t + UV.x * 2.0 + UV.y * 2.0);
//
    //COLOR = color;
//}

