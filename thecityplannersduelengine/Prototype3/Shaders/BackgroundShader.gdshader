shader_type canvas_item;

uniform vec4 color_top = vec4(0.18, 0.35, 0.18, 1.0);
uniform vec4 color_bottom = vec4(0.10, 0.22, 0.10, 1.0);

void fragment() {
    // Get normalized UV (0 to 1 across the screen)
    float t = UV.y;
    // Smooth vertical blend
    COLOR = mix(color_top, color_bottom, t);
}