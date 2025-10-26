shader_type canvas_item;
render_mode unshaded;

uniform ivec2 world_cell_size;
uniform float px_per_cell;
uniform vec2 px_position;

uniform vec4 color1 = vec4(0.3, 0.6, 0.2, 1.0); // green
uniform vec4 color2 = vec4(0.45, 0.33, 0.2, 1.0); // brown
uniform vec4 color3 = vec4(0.5, 0.5, 0.5, 1.0); // grey

uniform int edge_fade_cells = 20;
uniform float noise_scale = 0.15;    // how blocky the random patches are
uniform float noise_threshold = 0.5; // how often color3 appears

// Pseudo-random noise function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec2 pos = (px_position + FRAGCOORD.xy) / px_per_cell;
    int x = int(floor(pos.x));
    int y = int(floor(pos.y));

    // Checkerboard base
    bool is_even = ((x + y) % 2) == 0;
    vec4 base_color = is_even ? color1 : color2;

    // Randomly choose color3 on some cells
    float n = hash(vec2(float(x), float(y)) * noise_scale);
    if (n > noise_threshold) {
        base_color = color3;
    }

    // Edge fade
    int dx = min(x, world_cell_size.x - 1 - x);
    int dy = min(y, world_cell_size.y - 1 - y);
    int min_edge_dist = min(dx, dy);

    if (min_edge_dist < edge_fade_cells) {
        float t = float(min_edge_dist) / float(edge_fade_cells);
        base_color.rgb *= t;
    }

    COLOR = base_color;
}


