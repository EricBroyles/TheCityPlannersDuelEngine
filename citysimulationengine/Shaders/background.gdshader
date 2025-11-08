shader_type canvas_item;
render_mode unshaded;

uniform ivec2 world_cell_size;
uniform float px_per_cell;
uniform vec2 px_position;

// Colors normalized to 0..1
uniform vec3 color1 = vec3(0.647, 0.925, 0.588);
uniform vec3 color2 = vec3(0.475, 0.796, 0.408);
uniform vec3 color3 = vec3(0.255, 0.737, 0.157);

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

    // Checkerboard base color
    bool is_even = ((x + y) % 2) == 0;
    vec3 base_color = is_even ? color1 : color2;

    // Randomly override with color3 on some cells
    float n = hash(vec2(float(x), float(y)) * noise_scale);
    if (n > noise_threshold) {
        base_color = color3;
    }

    // Edge fade factor
    int dx = min(x, world_cell_size.x - 1 - x);
    int dy = min(y, world_cell_size.y - 1 - y);
    int min_edge_dist = min(dx, dy);

    float fade = 1.0;
    if (min_edge_dist < edge_fade_cells) {
        fade = float(min_edge_dist) / float(edge_fade_cells);
    }

    base_color *= fade;

    COLOR = vec4(base_color, 1.0);
}
