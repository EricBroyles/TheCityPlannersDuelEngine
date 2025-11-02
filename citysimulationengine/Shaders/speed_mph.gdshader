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

    if (my_speed_mph == 0) {
        discard; // fully transparent
    }

    vec3 color;
    float alpha = .5;

    if (my_speed_mph > 0 && my_speed_mph < 20) {
        // Map speed [1..19] to blue shades from dark to light
        // Normalize speed to [0..1]
        float norm = float(my_speed_mph) / 20.0;
        // Dark blue = vec3(0.0, 0.0, 0.3), light blue = vec3(0.5, 0.7, 1.0)
        color = mix(vec3(0.0, 0.0, 0.3), vec3(0.5, 0.7, 1.0), norm);
    }
    else if (my_speed_mph >= 20 && my_speed_mph <= 100) {
        // Map speed [20..100] to red shades from dark to light
        float norm = float(my_speed_mph - 20) / 80.0;
        // Dark red = vec3(0.3, 0.0, 0.0), light red = vec3(1.0, 0.5, 0.5)
        color = mix(vec3(0.3, 0.0, 0.0), vec3(1.0, 0.5, 0.5), norm);
    }
    else if (my_speed_mph > 100) {
        // Map speed [101..255] to yellow shades from dark to light
        float norm = float(my_speed_mph - 100) / 155.0;
        // Dark yellow = vec3(0.3, 0.3, 0.0), light yellow = vec3(1.0, 1.0, 0.5)
        color = mix(vec3(0.3, 0.3, 0.0), vec3(1.0, 1.0, 0.5), norm);
    }
    else {
        // fallback color, just in case
        color = vec3(1.0, 1.0, 1.0);
    }

    COLOR = vec4(color, alpha);
}
