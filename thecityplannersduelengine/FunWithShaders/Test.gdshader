shader_type canvas_item;

const float SQUARE_SIZE = 4.0;
const int GRID_SIZE = 9;

uniform mat4 canvas_transform; // Godot provides this automatically

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // FRAGCOORD.xy is local to the Sprite2D, so convert to global
    vec2 global_pos = (canvas_transform * vec4(FRAGCOORD.xy, 0.0, 1.0)).xy;

    // We want the grid to start at global (0,0)
    if (global_pos.x < 0.0 || global_pos.y < 0.0 ||
        global_pos.x >= float(GRID_SIZE) * SQUARE_SIZE ||
        global_pos.y >= float(GRID_SIZE) * SQUARE_SIZE) {
        discard;
    }

    // Determine which square this pixel belongs to
    vec2 cell = floor(global_pos / SQUARE_SIZE);

    // Deterministic random color for each cell
    float r = rand(cell);
    float g = rand(cell + 10.0);
    float b = rand(cell + 20.0);

    COLOR = vec4(r, g, b, 1.0);
}