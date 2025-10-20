shader_type canvas_item;

uniform sampler2D data_tex: source_color, filter_nearest, repeat_disable;
uniform vec2 data_tex_size;
uniform vec2 cell_size = vec2(40,40);

void fragment() {
    //vec2 scaled_uv = floor(UV * data_tex_size) / data_tex_size; //+ (0.5 / data_tex_size);
    //COLOR = texture(data_tex, scaled_uv);
	//COLOR = texture(data_tex, scaled_uv);
	
	//vec2 scaled_uv = floor(UV * cell_size) / cell_size + (0.5 / cell_size);
    //COLOR = texture(data_tex, scaled_uv);
	//COLOR = texture(data_tex, scaled_uv);
	
    //vec2 src_px = floor(UV * data_tex_size);
    //vec2 snapped_uv = (src_px + 0.5) / data_tex_size;
	//COLOR = texelFetch(data_tex, ivec2(snapped_uv), 0);
	
	COLOR = texture(data_tex, UV);
}

