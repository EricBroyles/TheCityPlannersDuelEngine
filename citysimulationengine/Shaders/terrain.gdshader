shader_type canvas_item;
render_mode unshaded;

// Terrain type colors are supplied externally
uniform vec4 terrain_type_colors[7];

uniform sampler2D world_terrain_type_tex : source_color, filter_nearest, repeat_disable;
uniform sampler2D world_terrain_mod_tex  : source_color, filter_nearest, repeat_disable;
uniform float px_per_cell;
uniform vec2 px_position;

// Phase between these three (tm_idx 1-4)
const vec4 PHASE_RED    = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 PHASE_YELLOW = vec4(1.0, 1.0, 0.0, 1.0);
const vec4 PHASE_GREEN  = vec4(0.0, 1.0, 0.0, 1.0);

// Light ↔ dark grey pulse (tm_idx == 5)
const vec4 GREY_LIGHT   = vec4(0.85, 0.85, 0.85, 1.0);
const vec4 GREY_DARK    = vec4(0.45, 0.45, 0.45, 1.0);

void fragment() {
    // Compute cell index
    vec2 cell_idx = floor((px_position + FRAGCOORD.xy) / px_per_cell);
    ivec2 tex_size = textureSize(world_terrain_type_tex, 0);
    vec2 cell_uv = cell_idx / vec2(tex_size);

    // Decode terrain IDs
    int tt_idx = int(texture(world_terrain_type_tex, cell_uv).r * 255.0);
    int tm_idx = int(texture(world_terrain_mod_tex, cell_uv).r * 255.0);

    // Base terrain color
    vec4 col = vec4(1.0);
    if (tt_idx >= 0 && tt_idx < 7) {
        col = terrain_type_colors[tt_idx];
    }

    if (tm_idx >= 1 && tm_idx <= 4) {
        float speed = float(tm_idx) * 1.2;
        float t = (sin(TIME * speed) + 1.0) * 0.5;

        // Interpolate red → yellow → green
		vec4 ryg = mix()
        //vec3 ry = mix(PHASE_RED, PHASE_YELLOW, t);
        //vec3 ryg = mix(ry, PHASE_GREEN, t);

        float a = t; // transparency pulses as well
        col = mix(col, vec4(ryg, a), a);
    }
   else if (tm_idx == 5) {
        float t = (sin(TIME * 2.0) + 1.0) * 0.5;
        vec3 pulse = mix(GREY_LIGHT, GREY_DARK, t);
        col = vec4(pulse, 1.0);
    }

    COLOR = col;
}
