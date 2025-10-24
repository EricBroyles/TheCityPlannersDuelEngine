shader_type canvas_item;
uniform sampler2D data_tex: source_color, filter_nearest, repeat_disable;

void fragment() {
	COLOR = texture(data_tex, UV);
}

