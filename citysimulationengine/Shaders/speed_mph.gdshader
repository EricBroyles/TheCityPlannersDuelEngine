shader_type canvas_item;
render_mode unshaded;

uniform sampler2D world_data_tex : source_color, filter_nearest, repeat_disable;
uniform float px_per_cell;
uniform vec2 px_position;

void fragment() {
    ivec2 tex_size = textureSize(world_data_tex, 0);
    vec2 cell_idx = floor((px_position + FRAGCOORD.xy) / px_per_cell);
    vec2 cell_uv = cell_idx / vec2(tex_size);

    int my_speed_mph = int(texture(world_data_tex, cell_uv).r * 255.0);
	
    float intensity = float(my_speed_mph) / 255.0;
    vec3 color = vec3(intensity);
    float alpha = (my_speed_mph == 0) ? 0.25 : 0.75;
    COLOR = vec4(color, alpha);
}
