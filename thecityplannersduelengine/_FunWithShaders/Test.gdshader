shader_type canvas_item;

uniform sampler2DArray tex_array;
uniform int start_idx;
uniform int end_idx;
uniform float px_per_cell;
uniform vec2 position_offset;

void vertex() {
    VERTEX += position_offset;
}


void fragment() {
    vec2 pixel_pos = FRAGCOORD.xy - position_offset; // position in pixels, relative to offset
    vec2 tex_pos = floor(pixel_pos / px_per_cell);   // which texel we’re inside
    vec2 local_uv = fract(pixel_pos / px_per_cell);  // position inside the texel (0–1)

    vec4 color = vec4(0.0);

    // Draw multiple layers (optional: blend them)
    for (int i = start_idx; i <= end_idx; i++) {
        // Convert tex_pos to normalized UV (0–1)
        vec2 tex_uv = tex_pos / vec2(textureSize(tex_array, 0).xy);
        vec4 tex_col = texture(tex_array, vec3(tex_uv, float(i)));

        // You could alpha-blend, or just overwrite
        color = mix(color, tex_col, tex_col.a);
    }

    COLOR = color;
}