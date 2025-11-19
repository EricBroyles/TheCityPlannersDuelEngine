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

group_id == rowwise idx but keep in mind when I say rowwise_idx it is a pointer to the smallest rowwise_idx i know this px is connected to.
*/
shader_type canvas_item;
render_mode unshaded; render_mode blend_disabled;

uniform sampler2D dir : source_color, filter_nearest, repeat_disable;
uniform sampler2D cm0 : source_color, filter_nearest, repeat_disable;
uniform uvec2 size;

const uint GROUP_ID_BITS = 30u;

const ivec2 TL_CELL_SHIFT = ivec2(-1,-1); //(c,r) + shift == top left cell
const ivec2  T_CELL_SHIFT = ivec2(+0,-1);
const ivec2 TR_CELL_SHIFT = ivec2(+1,-1);
const ivec2  L_CELL_SHIFT = ivec2(-1,+0);


uint extract_group_id(uvec4 px_255) {
	//px_255 = (xxxxxxxx) (yyyyyyyy) (zzzzzzzz) (wwwwwwDB)
	uint x = px_255.x << (GROUP_ID_BITS-8u);    // 00xxxxxx xx000000 00000000 00000000
	uint y = px_255.y << (GROUP_ID_BITS-2u*8u); // 00000000 00yyyyyy yy000000 00000000
	uint z = px_255.z << (GROUP_ID_BITS-3u*8u); // 00000000 00000000 00zzzzzz zz000000 
	uint w = px_255.w >> 2u; 					// 00000000 00000000 00000000 00wwwwww
	return x | y | z | w; 					    //00xxxxxx xxyyyyyy yyzzzzzz zzwwwwww
}

uint extract_delta(uvec4 px_255) {
	return (px_255.w >> 1u) & 1u; // xxxxxxDB >> 1 = 0xxxxxxD & 00000001 = 0000000D = 0/1 = f/t
}

uint extract_barrier(uvec4 px_255) {	
	return px_255.w & 1u; // xxxxxxDB & 00000001 = 0000000B = 0/1 = f/t
}

uvec3 read_cm0(vec2 uv) {
	/*
	IN : uv coordinates c:0->1, r:0->1 in cm0
	OUT: uvec3(group_id, delta, barrier)
	ASSUMES: 
		* px_255 == x:(bbbbbbbb) y:(bbbbbbbb) z:(bbbbbbbb) w:(bbbbbbDB)
	*/
	uvec4 px_255   = uvec4(texture(cm0, uv) * 255.0);
	uint  group_id = extract_group_id(px_255);
	uint  delta    = extract_delta(px_255);
	uint  barrier  = extract_barrier(px_255); 
	return uvec3(group_id, delta, barrier);
}

vec4 pack_cm1(uvec3 cm_px_struct) {
	/*
	IN: cm_px_struct = uvec3(group_id, delta, barrier)
	OUT: rgba8bit color
	*/
	//packed: rrrrrrrr gggggggg bbbbbbbb aaaaaaaa 
	uint group_id = cm_px_struct.x & 0x3FFFFFFFu; // 30 bits
	uint delta    = cm_px_struct.y & 1u;
	uint barrier  = cm_px_struct.z & 1u;
	uint packed = (group_id << 2u) | (delta << 1u) | barrier;
	
	float r = float((packed >> 24u) & 0xFFu) / 255.0;
	float g = float((packed >> 16u) & 0xFFu) / 255.0;
	float b = float((packed >>  8u) & 0xFFu) / 255.0;
	float a = float((packed >>  0u) & 0xFFu) / 255.0;
	return vec4(r,g,b,a);
}

uvec2 extract_idx(uint group_id) {
	/*
	IN: group_id == rowwise_idx 
	OUT: uvec2(col, row)
	Assumes: group_id is valid
	*/
	uint width = size.x;
	uint row = group_id / width;
	uint col = group_id % width;
	return uvec2(col, row);
}

bool in_lower_bounds(ivec2 idx) {
	return bool(idx.x >= 0 && idx.y >= 0);
}

bool in_upper_bounds(ivec2 idx) {
	return bool(idx.x < int(size.x) && idx.y < int(size.y));
}

bool nw_dir_allowed(vec2 uv) {
	// Top Left
	return (uint(texture(dir, uv).r * 255.0) & 8u) != 0u;
}

bool n_dir_allowed(vec2 uv) {
	// Top
	return (uint(texture(dir, uv).r * 255.0) & 4u) != 0u;
}

bool ne_dir_allowed(vec2 uv) {
	// Top Right
	return (uint(texture(dir, uv).r * 255.0) & 2u) != 0u;
}

bool w_dir_allowed(vec2 uv) {
	// Left
	return (uint(texture(dir, uv).r * 255.0) & 16u) != 0u;
}

vec2 idx_to_uv(ivec2 idx) {
	return vec2(idx) / (vec2(size) - vec2(1,1));
}

uvec2 tl_search_at(uint group_id) {
	/*
	Top left relative search at group_id == rowwise idx
	IN:  the group_id -> rowwise_idx -> uv to search relative to (in cm0 and dir)
	OUT: uvec2(success|failure, tl_group_id|group_id)
	Failure Conditions:
	* Top left cell relative to group_id is in lower bounds. (dont need to check upper bounds)
	* Top left cell relative to group_id is a barrier
	* Top left cell relative to group_id is not allowed to move to via dir
	*/
	
	ivec2 idx = ivec2(extract_idx(group_id));
	ivec2 tl_idx = idx + TL_CELL_SHIFT;
	if (!in_lower_bounds(tl_idx)) {return uvec2(uint(false), group_id);}
	
	vec2 uv = idx_to_uv(idx); // can current group_id move nw
	if (!nw_dir_allowed(uv)) 	  {return uvec2(uint(false), group_id);}
	
	vec2 tl_uv = idx_to_uv(tl_idx);
	uvec3 cm_px_struct = read_cm0(tl_uv);
	bool barrier = bool(cm_px_struct.z);
	if (barrier) 				  {return uvec2(uint(false), group_id);}
	
	uint tl_group_id = cm_px_struct.x;
	return uvec2(uint(true), tl_group_id);
}

uvec2 t_search_at(uint group_id) {
	/*
	Top relative search at group_id == rowwise idx
	*/
	ivec2 idx = ivec2(extract_idx(group_id));
	ivec2 t_idx = idx + T_CELL_SHIFT;
	if (!in_lower_bounds(t_idx)) {return uvec2(uint(false), group_id);}
	
	vec2 uv = idx_to_uv(idx); // can current group_id move n
	if (!n_dir_allowed(uv)) 	  {return uvec2(uint(false), group_id);}
	
	vec2 t_uv = idx_to_uv(t_idx);
	uvec3 cm_px_struct = read_cm0(t_uv);
	bool barrier = bool(cm_px_struct.z);
	if (barrier) 				  {return uvec2(uint(false), group_id);}
	
	uint t_group_id = cm_px_struct.x;
	return uvec2(uint(true), t_group_id);
}

uvec2 tr_search_at(uint group_id) {
	/*
	Top right relative search at group_id == rowwise idx
	(This needs to check th eupper bounds)
	*/
	ivec2 idx = ivec2(extract_idx(group_id));
	ivec2 tr_idx = idx + TR_CELL_SHIFT;
	if (!in_lower_bounds(tr_idx) || !in_upper_bounds(tr_idx)) {return uvec2(uint(false), group_id);}
	
	vec2 uv = idx_to_uv(idx); // can current group_id move ne
	if (!ne_dir_allowed(uv)) 	  {return uvec2(uint(false), group_id);}
	
	vec2 tr_uv = idx_to_uv(tr_idx);
	uvec3 cm_px_struct = read_cm0(tr_uv);
	bool barrier = bool(cm_px_struct.z);
	if (barrier) 				  {return uvec2(uint(false), group_id);}
	
	uint tr_group_id = cm_px_struct.x;
	return uvec2(uint(true), tr_group_id);
}

uvec2 l_search_at(uint group_id) {
	/*
	Left relative search at group_id == rowwise idx
	*/
	ivec2 idx = ivec2(extract_idx(group_id));
	ivec2 l_idx = idx + L_CELL_SHIFT;
	if (!in_lower_bounds(l_idx)) {return uvec2(uint(false), group_id);}
	
	vec2 uv = idx_to_uv(idx); // can current group_id move n
	if (!w_dir_allowed(uv)) 	  {return uvec2(uint(false), group_id);}
	
	vec2 l_uv = idx_to_uv(l_idx);
	uvec3 cm_px_struct = read_cm0(l_uv);
	bool barrier = bool(cm_px_struct.z);
	if (barrier) 				  {return uvec2(uint(false), group_id);}
	
	uint l_group_id = cm_px_struct.x;
	return uvec2(uint(true), l_group_id);
}

void fragment() {
	
	uvec3 cm_px_struct = read_cm0(UV);
	uint group_id = cm_px_struct.x;
	bool delta = bool(cm_px_struct.y); // Did this px change last iteration.
	bool barrier = bool(cm_px_struct.z);
	
	uint new_group_id = group_id;
	bool new_delta = false; // Did this px change this iteration.
	
	if (!barrier && delta) {
		
		// Top Left
		uvec2 tl_search_results = tl_search_at(group_id);
		bool did_find = bool(tl_search_results.x);
		if (did_find) {new_group_id = tl_search_results.y; new_delta = true;}
		
		// Top
		if (!new_delta) {
			uvec2 t_search_results = t_search_at(group_id);
			bool did_find = bool(t_search_results.x);
			if (did_find) {new_group_id = t_search_results.y; new_delta = true;}
		}
		// Top Right
		if (!new_delta) {
			uvec2 tr_search_results = tr_search_at(group_id);
			bool did_find = bool(tr_search_results.x);
			if (did_find) {new_group_id = tr_search_results.y; new_delta = true;}
		}
		// Left
		if (!new_delta) {
			uvec2 l_search_results = l_search_at(group_id);
			bool did_find = bool(l_search_results.x);
			if (did_find) {new_group_id = l_search_results.y; new_delta = true;}
		}
		
	}
	
	cm_px_struct.x = new_group_id;
	cm_px_struct.y = uint(new_delta);
	COLOR = pack_cm1(cm_px_struct);
}



/*
SOme Tests
*/

//void fragment() {
	//// Test tl_search
	//
	////uvec2 res = tl_search_at(0);
	////uvec2 ans = uvec2(0,0); //false, group_id = 0
	//
	////uvec2 res = tl_search_at(1);
	////uvec2 ans = uvec2(0,1); //false, group_id = 1
	//
	////uvec2 res = tl_search_at(10);
	////uvec2 ans = uvec2(0,10); //true, group_id = 10
	//
	////uvec2 res = tl_search_at(11);
	////uvec2 ans = uvec2(1,0); //true, group_id = 0 (found 0 in tl)
	//
	////uvec2 res = tl_search_at(12); 
	////uvec2 ans = uvec2(1,1); //true, group_id = 1 (found 1 in tl)
	////
	////if (res == ans) {
		////COLOR = vec4(1);
	////}
	////else {
		////COLOR = vec4(0);
	////}
	//
	//
	//
	////// test dir allowed
	////if (nw_dir_allowed(UV)) {
		////COLOR = vec4(1);
	////}
	////else {
		////COLOR = vec4(0);
	////}
	//
	////// Check extract idx 
	////uvec2 idx = extract_idx(12);
	////if (idx == uvec2(2,1)) {
		////COLOR = vec4(1);
	////}
	////else {
		////COLOR = vec4(0);
	////}
//}


/*
FOR FURTURE REFERENCE

*/

	//uvec3 cm_px_struct = read_cm0(UV); //uvec3(group_id, delta, barrier)
	//if (cm_px_struct.x == 0u){
		//COLOR = vec4(1,1,1,1);
	//}
	//COLOR = vec4(0,0,0,0);
	//COLOR = pack_cm1(cm_px_struct);
	
	//uvec4(0u,0u,0u,0u) -> group id == 0u, D = 0 B = 0 (WORKS)
	//uvec4(0u,0u,0u,1u) -> group id == 0u, D = 0 B = 1 (WORKS)
	//uvec4(0u,0u,0u,2u) -> group id == 0u, D = 1 B = 0 (WORKS)
	//uvec4(0u,0u,0u,3u) -> group id == 0u, D = 1 B = 1 (WORKS)
	//uvec4(0u,0u,0u,4u) -> group id == 1u, D = 0 B = 0 (WORKS)
	
	//if (extract_group_id(uvec4(0u,0u,0u,4u)) == 1u) {
		//COLOR = vec4(1,1,1,1);
	//}
	//else {
		//COLOR = vec4(0,0,0,0);
	//}



//uvec4 get_px_255(sampler2D m,vec2 uv) {
	//return uvec4(texture(m, uv) * 255.0); //channels [0:255]
//}
//
//vec4 px_255_to_color(uvec4 px_255) {
	//return vec4(px_255) / 255.0;
//}
//
//bool is_barrier(uvec4 px_255) {
	//// px_255: get "w" channel, 0 -> 255
	//// xxxxxxxB & 00000001 = 0000000B = 0/1 = f/t
	//return bool(px_255.w & 1u);
//}
//
//uvec2 extract_idx(uvec4 px_255) {
	//// px_255 x:(bbbbbbbb) y:(bbbbbbbb) z:(bbbbbbbb) w:(bbbbbbDB)
	//// rowwise_idx = row * width + col
	//uint x = px_255.x << (ROWWISE_IDX_BITS-8u);   // xxxxxxxx 00000000 00000000 000000
	//uint y = px_255.y << (ROWWISE_IDX_BITS-2u*8u); // yyyyyyyy 00000000 000000
	//uint z = px_255.z << (ROWWISE_IDX_BITS-3u*8u); // zzzzzzzz 000000
	//uint w = px_255.w << 0u; 						// wwwwww
	//uint rowwise_idx = x | y | z | w; // xxxxxxxx yyyyyyyy zzzzzzzz wwwwww
	//uint width = size.x;
	//uint row = rowwise_idx / width;
	//uint col = rowwise_idx % width;
	//return uvec2(col, row);
//}
//
//vec2 idx_to_uv(uvec2 idx) {
	//return vec2(idx) / vec2(size);
//}
//
//bool in_lower_bounds(ivec2 idx) {
	//return bool(idx.x >= 0 && idx.y >= 0);
//}
//
//bool in_upper_bounds(ivec2 idx) {
	//return bool(idx.x < int(size.x) && idx.y < int(size.y));
//}
//
//bool nw_dir_allowed(uvec2 idx) {
	//return (get_px_255(dir, idx_to_uv(idx)).r & 8u) != 0u;
//}
//
//bool n_dir_allowed(uvec2 idx) {
	//return (get_px_255(dir, idx_to_uv(idx)).r & 4u) != 0u;
//}
//
//bool ne_dir_allowed(uvec2 idx) {
	//return (get_px_255(dir, idx_to_uv(idx)).r & 2u) != 0u;
//}
//
//bool w_dir_allowed(uvec2 idx) {
	//return (get_px_255(dir, idx_to_uv(idx)).r & 16u) != 0u;
//}
//
//uvec4 pack_delta_into_px_255(uvec4 px_255, bool delta) {
	//// px_255 x:(bbbbbbbb) y:(bbbbbbbb) z:(bbbbbbbb) w:(bbbbbbDB)
	//// change D to have the value of delta
	//// convert bool → 0 or 1
    //uint d = uint(delta);
    //px_255.w &= ~(1u << 1u);  // clear bit 1
    //px_255.w |= (d << 1u); // set bit 1 to new delta value
    //return px_255;
//}
//
//void fragment() {
	//uvec4 final_px_255 = get_px_255(cm0, UV);
	//bool delta = false;
	//
	//if (!is_barrier(final_px_255)) {
		//// Find the idx encoded on final_px_255
		//uvec2 idx = extract_idx(final_px_255);
		//uvec4 new_final_px_255;
		//
		////Top Left
		//ivec2 tl_idx = ivec2(idx) + ivec2(-1,-1);
		//if ( in_lower_bounds(tl_idx) ) {
			//uvec2 tl_uidx = uvec2(tl_idx);
			//if ( nw_dir_allowed(tl_uidx) ) {
				//new_final_px_255 = get_px_255(cm0, idx_to_uv(tl_uidx));
				//if (!is_barrier(new_final_px_255)) {
					//delta = true;
					//final_px_255 = new_final_px_255;
				//}
			//}	
		//}
		//
		////Top
		//if (!delta) {
			//ivec2 t_idx = ivec2(idx) + ivec2(-1,+0);
			//if ( in_lower_bounds(t_idx) ) {
				//uvec2 t_uidx = uvec2(t_idx);
				//if ( n_dir_allowed(t_uidx) ) {
					//new_final_px_255 = get_px_255(cm0, idx_to_uv(t_uidx));
					//if (!is_barrier(new_final_px_255)) {
						//delta = true;
						//final_px_255 = new_final_px_255;
					//}
				//}
			//}
		//}
		//
		////Top Right
		//if (!delta) {
			//ivec2 tr_idx = ivec2(idx) + ivec2(-1,+1);
			//if ( in_lower_bounds(tr_idx) && in_upper_bounds(tr_idx) ) {
				//uvec2 tr_uidx = uvec2(tr_idx);
				//if ( ne_dir_allowed(tr_uidx) ) {
					//new_final_px_255 = get_px_255(cm0, idx_to_uv(tr_uidx));
					//if (!is_barrier(new_final_px_255)) {
						//delta = true;
						//final_px_255 = new_final_px_255;
					//}
				//}
			//}
		//}
		//
		////Left
		//if (!delta) {
			//ivec2 l_idx = ivec2(idx) + ivec2(+0,-1);
			//if ( in_lower_bounds(l_idx) ) {
				//uvec2 l_uidx = uvec2(l_idx);
				//if ( w_dir_allowed(l_uidx) ) {
					//new_final_px_255 = get_px_255(cm0, idx_to_uv(l_uidx));
					//if (!is_barrier(new_final_px_255)) {
						//delta = true;
						//final_px_255 = new_final_px_255;
					//}
				//}
			//}
		//}
	//}
	//final_px_255 = pack_delta_into_px_255(final_px_255, delta);
	//COLOR = px_255_to_color(final_px_255);
//}
	
	
	


