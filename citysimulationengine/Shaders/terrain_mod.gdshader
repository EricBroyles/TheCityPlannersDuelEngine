shader_type canvas_item;
render_mode unshaded;

uniform sampler2D world_data_tex  : source_color, filter_nearest, repeat_disable;
uniform float px_per_cell;
uniform vec2 px_position;

// Circle shape settings
uniform float radius = 0.4;   // circle radius in UV-local space (0–0.7 usually)
uniform float feather = 0.02; // smoother edge
uniform float speed = .1;

// Phase between these three (tm_idx 1-4)
const vec4 PHASE_RED    = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 PHASE_YELLOW = vec4(1.0, 1.0, 0.0, 1.0);
const vec4 PHASE_GREEN  = vec4(0.0, 1.0, 0.0, 1.0);

// Light ↔ dark grey pulse (tm_idx == 5)
const vec4 GREY_LIGHT   = vec4(0.85, 0.85, 0.85, 1.0);
const vec4 GREY_DARK    = vec4(0.45, 0.45, 0.45, 1.0);

void fragment() {
    ivec2 tex_size = textureSize(world_data_tex, 0);
    
    vec2 world_pos_px = px_position + FRAGCOORD.xy;
    vec2 cell_idx = floor(world_pos_px / px_per_cell);
    vec2 cell_uv = cell_idx / vec2(tex_size);
    
    int my_mod = int(texture(world_data_tex, cell_uv).r * 255.0);

    if (my_mod == 0) {
        discard;
    }
    
    vec2 cell_start_px = cell_idx * px_per_cell - px_position;
    vec2 local_px = FRAGCOORD.xy - cell_start_px;
    vec2 local = (local_px / px_per_cell) - vec2(0.5);
    
    float dist = length(local);
    float mask = 1.0 - smoothstep(radius, radius + feather, dist);
    
    if (mask <= 0.0) {
        discard;
    }
    
    vec4 final_color;
    float alpha = 1.0;

    if (my_mod == 1) {
        // Solid red, fully opaque
        final_color = PHASE_RED;
        alpha = 1.0;
    }
    else if (my_mod >= 2 && my_mod <= 4) {
        float t = fract(TIME * speed);

        if (t < 0.33) {
            float f = t / 0.33;
            final_color = mix(PHASE_RED, PHASE_YELLOW, f);
        } else if (t < 0.66) {
            float f = (t - 0.33) / 0.33;
            final_color = mix(PHASE_YELLOW, PHASE_GREEN, f);
        } else {
            float f = (t - 0.66) / 0.34;
            final_color = mix(PHASE_GREEN, PHASE_RED, f);
        }
        // Set alpha based on my_mod
        if (my_mod == 2) alpha = 0.8;
        else if (my_mod == 3) alpha = 0.7;
        else if (my_mod == 4) alpha = 0.6;
    }
    else if (my_mod == 5) {
        float t = abs(sin(TIME * speed));
        final_color = mix(GREY_DARK, GREY_LIGHT, t);
        alpha = 0.8;
    }
    else {
        discard;
    }

    COLOR = vec4(final_color.rgb, alpha) * mask;
}

