shader_type canvas_item;
render_mode unshaded;

uniform sampler2D world_data_tex  : source_color, filter_nearest, repeat_disable;
uniform float px_per_cell;
uniform vec2 px_position;

void fragment() {
	COLOR = vec4(1.0,0,1.0,1.0);
}


//shader_type canvas_item;
//render_mode unshaded;
//
//// Circle radius in normalized screen UV space (0.0–0.5)
//uniform float radius = 0.3;
//// Optional smooth edge feather
//uniform float feather = 0.01;
//// Speed of color shifting
//uniform float speed = 1.0;
//
//void fragment() {
    //// Time-based phase
    //float t = fract(TIME * speed);
//
    //vec3 color;
//
    //if (t < 0.5) {
        //float f = t / 0.5;
        //color = mix(vec3(1.0, 0.0, 0.0), vec3(1.0, 1.0, 0.0), f);
    //} else {
        //float f = (t - 0.5) / 0.5;
        //color = mix(vec3(1.0, 1.0, 0.0), vec3(0.0, 1.0, 0.0), f);
    //}
//
    //// Center of UV is (0.5, 0.5)
    //float dist = distance(UV, vec2(0.5));
//
    //// Smoothly fade at edges
    //float mask = 1.0 - smoothstep(radius - feather, radius, dist);
//
    //// Output
    //COLOR = vec4(color, mask);
//}




//SAVE
//shader_type canvas_item;
//
//uniform vec3 data = vec3(0, 0, 1.0); // (rotation°, magnitude, exists)
//uniform float speed = 0.25;               // how fast the yellow spreads
//uniform float width = 0.05;               // thickness of yellow wave
//
//void fragment() {
    //// UV centered at (0,0) from [-1,1]
    //vec2 p = (UV - 0.5) * 2.0;
//
    //// --- Background color ---
    //vec3 base_color;
    //if (data.z > 0.5) {
        //// magnitude → grayscale
        //base_color = vec3(data.y);
    //} else {
        //// no data → dark background
        //base_color = vec3(0.05);
    //}
//
    //// --- Compute directional radial pulse ---
    //// Convert angle to radians
    //float angle = radians(data.x);
//
    //// Direction unit vector from rotation
    //vec2 dir = vec2(cos(angle), sin(angle));
//
    //// Project pixel onto direction to find distance along direction
    //float dist = -dot(p, dir);
//
    //// Time-based wave traveling outward
    //float wave = fract(TIME * speed);
//
    //// Create a sharp band of yellow that moves over TIME
    //float highlight = smoothstep(wave - width, wave, dist) 
                    //* (1.0 - smoothstep(wave, wave + width, dist));
//
    //// Yellow color overlay
    //vec3 yellow = vec3(1.0, 1.0, 0.0);
//
    //// Mix highlight over base
    //vec3 final_color = mix(base_color, yellow, highlight);
//
    //COLOR = vec4(final_color, 1.0);
//}