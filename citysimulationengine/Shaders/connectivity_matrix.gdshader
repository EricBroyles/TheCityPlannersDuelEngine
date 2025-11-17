shader_type canvas_item;
render_mode unshaded;

/*
Direction Matrix: dir
	- IMAGE: R8
	- SIZE: RxC
	- 8 bits: e,ne,n,nw,w,sw,s,se
	- indicate the allowed movement directions for any given px

Connectivity Matrix: CM
	- IMAGE: RGBA8bit
	- SIZE: RxC
	- 32 bits:  ( 8 bit ) ( 8 bit ) ( 8 bit ) ( 6 bit delta barrier)
	bit index: 7 6 5 4 3 2 1 0
	meaning:   x x x x x x D B
	- barrier: is px a barrier
	- delta: set to true if px changed this iteration, otherwise false
	- 30 bits = (0 -> 1,073,741,823) represents a rowwise idx. This idx in turn represents the id of the group the px is connected to.

Connectivity Matrix Algorithm:
	1. cm0 = checking terrain_type (none, or barrier or ...) and direction (none) to create barriers, and give each px a unique_group_id == px_rowwise_idx
	2. pass cm0 to shader
	3. Simplify Groups: draw a new texture (cm1) to the screen
		at each px: 
		IF barrier: color stays the same
		ELSE: get the px_rowwise_idx and look in cm0 at that idx. look at cells that could have a smaller idx (up or to the left) (check for out of bounds, ignore barriers)
			 set px to smallest idx
	4. screen capture cm1
	5. cm0 = cm1
	6. repeat step2 13 times (2^13 > 5000 so it will complete a 5000 x 5000).
	7. Check for delta: need to look through cm0 and see if any delta are valid
		New shader gets passed cm0. extract delta bit at each px. 
		if delta == true: set the COLOR == (0,0,0,1)
		else COLOR == (0,0,0,0)
		Screen capture this.
		use Image.is_invisible()
		ALTERNATE: just look the bit data for cm0
	8. if has not changed -> end otherwise repreat step2.
	
NOTE: due to the nature of rowwise idx the smallest relative to a given cell is upperleft, up, upperright, left, self, all others will be larger if the exist.

POTENTIAL ISSUE with drawing to texture larger than screen size, may need custom viewports that match the size

*/


uniform sampler2D dir;
uniform sampler2D cm0;
uniform uvec2 size;

const uint ROWWISE_IDX_BITS = 30u;

uvec4 get_px_255(sampler2D m,vec2 uv) {
	return uvec4(texture(m, uv) * 255.0); //channels [0:255]
}

vec4 px_255_to_color(uvec4 px_255) {
	return vec4(px_255) / 255.0;
}

bool is_barrier(uvec4 px_255) {
	// px_255: get "w" channel, 0 -> 255
	// xxxxxxxB & 00000001 = 0000000B = 0/1 = f/t
	return bool(px_255.w & 1u);
}

uvec2 extract_idx(uvec4 px_255) {
	// px_255 x:(bbbbbbbb) y:(bbbbbbbb) z:(bbbbbbbb) w:(bbbbbbDB)
	// rowwise_idx = row * width + col
	uint x = px_255.x << (ROWWISE_IDX_BITS-8u);   // xxxxxxxx 00000000 00000000 000000
	uint y = px_255.y << (ROWWISE_IDX_BITS-2u*8u); // yyyyyyyy 00000000 000000
	uint z = px_255.z << (ROWWISE_IDX_BITS-3u*8u); // zzzzzzzz 000000
	uint w = px_255.w << 0u; 						// wwwwww
	uint rowwise_idx = x | y | z | w; // xxxxxxxx yyyyyyyy zzzzzzzz wwwwww
	uint width = size.x;
	uint row = rowwise_idx / width;
	uint col = rowwise_idx % width;
	return uvec2(col, row);
}

vec2 idx_to_uv(uvec2 idx) {
	return vec2(idx) / vec2(size);
}

bool in_lower_bounds(ivec2 idx) {
	return bool(idx.x >= 0 && idx.y >= 0);
}

bool in_upper_bounds(ivec2 idx) {
	return bool(idx.x < int(size.x) && idx.y < int(size.y));
}

bool nw_dir_allowed(uvec2 idx) {
	return (get_px_255(dir, idx_to_uv(idx)).r & 8u) != 0u;
}

bool n_dir_allowed(uvec2 idx) {
	return (get_px_255(dir, idx_to_uv(idx)).r & 4u) != 0u;
}

bool ne_dir_allowed(uvec2 idx) {
	return (get_px_255(dir, idx_to_uv(idx)).r & 2u) != 0u;
}

bool w_dir_allowed(uvec2 idx) {
	return (get_px_255(dir, idx_to_uv(idx)).r & 16u) != 0u;
}

uvec4 pack_delta_into_px_255(uvec4 px_255, bool delta) {
	// px_255 x:(bbbbbbbb) y:(bbbbbbbb) z:(bbbbbbbb) w:(bbbbbbDB)
	// change D to have the value of delta
	// convert bool → 0 or 1
    uint d = uint(delta);
    px_255.w &= ~(1u << 1u);  // clear bit 1
    px_255.w |= (d << 1u); // set bit 1 to new delta value
    return px_255;
}

void fragment() {
	uvec4 final_px_255 = get_px_255(cm0, UV);
	bool delta = false;
	
	if (!is_barrier(final_px_255)) {
		// Find the idx encoded on final_px_255
		uvec2 idx = extract_idx(final_px_255);
		uvec4 new_final_px_255;
		
		//Top Left
		ivec2 tl_idx = ivec2(idx) + ivec2(-1,-1);
		if ( in_lower_bounds(tl_idx) ) {
			uvec2 tl_uidx = uvec2(tl_idx);
			if ( nw_dir_allowed(tl_uidx) ) {
				new_final_px_255 = get_px_255(cm0, idx_to_uv(tl_uidx));
				if (!is_barrier(new_final_px_255)) {
					delta = true;
					final_px_255 = new_final_px_255;
				}
			}	
		}
		
		//Top
		if (!delta) {
			ivec2 t_idx = ivec2(idx) + ivec2(-1,+0);
			if ( in_lower_bounds(t_idx) ) {
				uvec2 t_uidx = uvec2(t_idx);
				if ( n_dir_allowed(t_uidx) ) {
					new_final_px_255 = get_px_255(cm0, idx_to_uv(t_uidx));
					if (!is_barrier(new_final_px_255)) {
						delta = true;
						final_px_255 = new_final_px_255;
					}
				}
			}
		}
		
		//Top Right
		if (!delta) {
			ivec2 tr_idx = ivec2(idx) + ivec2(-1,+1);
			if ( in_lower_bounds(tr_idx) && in_upper_bounds(tr_idx) ) {
				uvec2 tr_uidx = uvec2(tr_idx);
				if ( ne_dir_allowed(tr_uidx) ) {
					new_final_px_255 = get_px_255(cm0, idx_to_uv(tr_uidx));
					if (!is_barrier(new_final_px_255)) {
						delta = true;
						final_px_255 = new_final_px_255;
					}
				}
			}
		}
		
		//Left
		if (!delta) {
			ivec2 l_idx = ivec2(idx) + ivec2(+0,-1);
			if ( in_lower_bounds(l_idx) ) {
				uvec2 l_uidx = uvec2(l_idx);
				if ( w_dir_allowed(l_uidx) ) {
					new_final_px_255 = get_px_255(cm0, idx_to_uv(l_uidx));
					if (!is_barrier(new_final_px_255)) {
						delta = true;
						final_px_255 = new_final_px_255;
					}
				}
			}
		}
	}
	final_px_255 = pack_delta_into_px_255(final_px_255, delta);
	COLOR = px_255_to_color(final_px_255);
}
	
	
	


