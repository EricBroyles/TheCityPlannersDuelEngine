shader_type canvas_item;
render_mode unshaded;

uniform vec4 color_map[7];

uniform sampler2D world_data_tex : source_color, filter_nearest, repeat_disable;
uniform float px_per_cell;
uniform vec2 px_position;

void fragment() {
    // Compute cell index
    vec2 cell_idx = floor((px_position + FRAGCOORD.xy) / px_per_cell);
    ivec2 tex_size = textureSize(world_data_tex, 0);
    vec2 cell_uv = cell_idx / vec2(tex_size);

    // Decode terrain IDs
    int idx = int(texture(world_data_tex, cell_uv).r * 255.0);

    // Base terrain color
    vec4 c = vec4(1.0);
    if (idx >= 0 && idx < 7) {
        c = color_map[idx];
    }

    COLOR = c;
}


