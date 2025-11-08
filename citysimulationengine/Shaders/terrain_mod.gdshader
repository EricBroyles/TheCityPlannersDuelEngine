shader_type canvas_item;
render_mode unshaded;

uniform sampler2D junction_stop : source_color, filter_nearest, repeat_disable; //100x100 texture added via inspector
uniform sampler2D junction1 : source_color, filter_nearest, repeat_disable; //100x100 texture added via inspector
uniform sampler2D junction2 : source_color, filter_nearest, repeat_disable; //100x100 texture added via inspector
uniform sampler2D junction3 : source_color, filter_nearest, repeat_disable; //100x100 texture added via inspector

uniform sampler2D world_data_tex : source_color, filter_nearest, repeat_disable;
uniform float px_per_cell;
uniform vec2 px_position;

void fragment() {
    ivec2 tex_size = textureSize(world_data_tex, 0);

    // Compute cell index this pixel belongs to
    vec2 world_pos_px = px_position + FRAGCOORD.xy;
    vec2 cell_idx = floor(world_pos_px / px_per_cell);
    vec2 cell_uv = cell_idx / vec2(tex_size);

    int my_mod = int(texture(world_data_tex, cell_uv).r * 255.0);

    if (my_mod == 0) {
        discard;
    }

    // Calculate local pixel coordinates within the cell (0..px_per_cell)
    vec2 cell_start_px = cell_idx * px_per_cell - px_position;
    vec2 local_px = FRAGCOORD.xy - cell_start_px;

    // Convert local_px to [0..1] UV for sampling the full-cell texture
    vec2 icon_uv = local_px / px_per_cell;

    vec4 col;

    if (my_mod == 1) {
        col = texture(junction_stop, icon_uv);
    } else if (my_mod == 2) {
        col = texture(junction1, icon_uv);
    } else if (my_mod == 3) {
        col = texture(junction2, icon_uv);
    } else if (my_mod == 4) {
        col = texture(junction3, icon_uv);
    } else if (my_mod == 5) {
        col = vec4(1.0); // white full cell
    } else {
        discard;
    }

    // Discard fully transparent pixels if any
    if (col.a < 0.01) {
        discard;
    }

    COLOR = col;
}


    
