shader_type canvas_item;
render_mode unshaded;

uniform sampler2D e_arrow : source_color, filter_nearest, repeat_disable; // black arrow pointing east at the edge of 100x100 frame
uniform sampler2D ne_arrow: source_color, filter_nearest, repeat_disable; // black arrow pointing ne at the edge of 100x100 frame

uniform sampler2D world_data_tex : source_color, filter_nearest, repeat_disable;
uniform float px_per_cell;
uniform vec2 px_position;

vec2 rotate_uv_90_ccw(vec2 uv, int rotations) {
    rotations = rotations % 4;

    if (rotations == 0) return uv;
    else if (rotations == 1) return vec2(1.0 - uv.y, uv.x);
    else if (rotations == 2) return vec2(1.0 - uv.x, 1.0 - uv.y);
    else /* rotations == 3 */ return vec2(uv.y, 1.0 - uv.x);
}

void fragment() {
	vec2 cell_idx = floor((px_position + FRAGCOORD.xy) / px_per_cell);
    ivec2 tex_size = textureSize(world_data_tex, 0);
    vec2 cell_uv = cell_idx / vec2(tex_size);
	
	// Decode bitmask (each bit corresponds to one direction) 
	int my_dir = int(texture(world_data_tex, cell_uv).r * 255.0);
	if (my_dir == 0) { discard; } //0 == no direction 00000000
	bool e = (my_dir & 1) != 0; 
	bool ne = (my_dir & 2) != 0; 
	bool n = (my_dir & 4) != 0; 
	bool nw = (my_dir & 8) != 0; 
	bool w = (my_dir & 16) != 0; 
	bool sw = (my_dir & 32) != 0; 
	bool s = (my_dir & 64) != 0; 
	bool se = (my_dir & 128) != 0;
	
    // Calculate local pixel coordinates within the cell (0..px_per_cell)
    vec2 cell_start_px = cell_idx * px_per_cell - px_position;
    vec2 local_px = FRAGCOORD.xy - cell_start_px;

    // Convert local_px to [0..1] UV for sampling the full-cell texture
    vec2 icon_uv = local_px / px_per_cell;
	
	//look at each texture if the color is not transparent the that is the color (no blending needed as there is no overlap)
	vec4 color = vec4(0.0);
	
	if (color == vec4(0.0) && e)  { color = texture(e_arrow, icon_uv);  }
	if (color == vec4(0.0) && n)  { color = texture(e_arrow, rotate_uv_90_ccw(icon_uv, 1)); }
	if (color == vec4(0.0) && w)  { color = texture(e_arrow, rotate_uv_90_ccw(icon_uv, 2)); }
	if (color == vec4(0.0) && s)  { color = texture(e_arrow, rotate_uv_90_ccw(icon_uv, 3)); }
	
	if (color == vec4(0.0) && ne) { color = texture(ne_arrow, icon_uv); }
	if (color == vec4(0.0) && nw) { color = texture(ne_arrow, rotate_uv_90_ccw(icon_uv, 1)); }
	if (color == vec4(0.0) && sw) { color = texture(ne_arrow, rotate_uv_90_ccw(icon_uv, 2)); }
	if (color == vec4(0.0) && se) { color = texture(ne_arrow, rotate_uv_90_ccw(icon_uv, 3)); }	
	
	COLOR = color;
}



//// SAVE FOR LATER: RADIAL GRADIENT FIELD
// Convert 8-bit direction mask to a normalized direction vector
//vec2 decode_dir(int mask) {
    //vec2 d = vec2(0.0);
    //if ((mask & 1) != 0)  d += vec2(1.0, 0.0);   // E
    //if ((mask & 2) != 0)  d += vec2(1.0, -1.0);  // NE
    //if ((mask & 4) != 0)  d += vec2(0.0, -1.0);  // N
    //if ((mask & 8) != 0)  d += vec2(-1.0, -1.0); // NW
    //if ((mask & 16) != 0) d += vec2(-1.0, 0.0);  // W
    //if ((mask & 32) != 0) d += vec2(-1.0, 1.0);  // SW
    //if ((mask & 64) != 0) d += vec2(0.0, 1.0);   // S
    //if ((mask & 128) != 0) d += vec2(1.0, 1.0);  // SE
    //return normalize(d);
//}
//void fragment() {
    //// ---------------------------------------------------------------
    //// 1. Figure out which cell this pixel belongs to
    //// ---------------------------------------------------------------
    //vec2 cell_idx = floor((px_position + FRAGCOORD.xy) / px_per_cell);
//
    //ivec2 tex_size = textureSize(world_data_tex, 0);
    //vec2 cell_uv = cell_idx / vec2(tex_size);
//
    //// ---------------------------------------------------------------
    //// 2. Read the direction bitmask
    //// ---------------------------------------------------------------
    //int mask = int(texture(world_data_tex, cell_uv).r * 255.0);
//
    //vec2 dir = decode_dir(mask);
    //if (dir == vec2(0.0)) {
        //// cell has no direction
        //discard;
    //}
//
    //// ---------------------------------------------------------------
    //// 3. Compute pixel position inside its cell (UV 0–1)
    //// ---------------------------------------------------------------
    //vec2 p = (px_position + FRAGCOORD.xy) / px_per_cell;
    //p = fract(p) - 0.5;   // center cell at origin: (-0.5 to 0.5)
//
    //// ---------------------------------------------------------------
    //// 4. Gradient strength = alignment * falloff
    //// ---------------------------------------------------------------
    //float alignment = max(dot(normalize(p), dir), 0.0);
//
    //float dist = length(p);
    //float falloff = smoothstep(0.5, 0.0, dist);
//
    //float intensity = alignment * falloff;
//
    //// ---------------------------------------------------------------
    //// 5. Output colored gradient
    //// ---------------------------------------------------------------
    //COLOR = vec4(vec3(intensity), 1.0);  // white gradient
    //// To make it yellow: vec4(intensity, intensity, 0.0, 1.0)
//}


