shader_type canvas_item;
render_mode unshaded;

// Controls
uniform float scale = 0.005;          // Terrain frequency
uniform float rock_threshold = 0.65;  // Higher -> fewer rocks
uniform float height_variation = 0.4; // Controls terrain bumpiness
uniform vec2 offset;                  // Can be randomized for variation

// Define terrain colors
const vec3 GRASS_LIGHT = vec3(0.4, 0.7, 0.3);
const vec3 GRASS_MED   = vec3(0.3, 0.6, 0.2);
const vec3 GRASS_DARK  = vec3(0.2, 0.5, 0.1);

const vec3 ROCK_LIGHT  = vec3(0.7, 0.7, 0.7);
const vec3 ROCK_MED    = vec3(0.5, 0.5, 0.5);
const vec3 ROCK_DARK   = vec3(0.3, 0.3, 0.3);

// Simple 2D noise function
float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(
		mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
		mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x),
		u.y
	);
}

float fbm(vec2 p) {
	float value = 0.0;
	float amplitude = 0.5;
	for (int i = 0; i < 4; i++) {
		value += amplitude * noise(p);
		p *= 2.0;
		amplitude *= 0.5;
	}
	return value;
}

void fragment() {
	vec2 uv = FRAGCOORD.xy * scale + offset;

	// Height map via FBM noise
	float terrain_height = fbm(uv) * height_variation + 0.5;

	// Rock mask (higher = more rock)
	float rock_mask = fbm(uv * 2.5 + vec2(100.0)) - rock_threshold;

	vec3 color;

	if (rock_mask > 0.0) {
		// Blend between 3 rock shades based on height
		if (terrain_height < 0.45)
			color = ROCK_DARK;
		else if (terrain_height < 0.6)
			color = ROCK_MED;
		else
			color = ROCK_LIGHT;
	} else {
		// Blend between 3 terrain shades based on height
		if (terrain_height < 0.45)
			color = GRASS_DARK;
		else if (terrain_height < 0.6)
			color = GRASS_MED;
		else
			color = GRASS_LIGHT;
	}

	COLOR = vec4(color, 1.0);
}