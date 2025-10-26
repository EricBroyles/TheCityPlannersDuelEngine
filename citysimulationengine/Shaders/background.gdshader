shader_type canvas_item;
render_mode unshaded;

uniform vec4 color1 = vec4(0.1, 0.6, 0.2, 1.0);
uniform vec4 color2 = vec4(0.05, 0.3, 0.1, 1.0);
uniform float px_per_cell;
uniform vec2 px_position; 

void fragment() {
    vec2 pos = (px_position + FRAGCOORD.xy) / px_per_cell;
    int x = int(floor(pos.x));
    int y = int(floor(pos.y));
    bool is_even = ( (x + y) % 2 ) == 0;
    COLOR = is_even ? color1 : color2;
}


