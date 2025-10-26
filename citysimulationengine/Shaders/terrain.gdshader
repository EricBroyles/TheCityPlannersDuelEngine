shader_type canvas_item;
render_mode unshaded;

uniform sampler2D world_data_tex: source_color, filter_nearest, repeat_disable;
uniform float px_per_cell;
uniform vec2 px_position; 

void fragment() {
	vec2 cell_idx = (px_position + FRAGCOORD.xy) / px_per_cell;
    vec2 cell_uv = cell_idx / vec2(textureSize(world_data_tex, 0));
    COLOR = texture(world_data_tex, cell_uv);
}
