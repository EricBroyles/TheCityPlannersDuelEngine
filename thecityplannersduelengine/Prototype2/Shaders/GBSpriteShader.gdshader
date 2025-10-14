shader_type canvas_item;

uniform sampler2D image_texture;
uniform vec2 image_size; // e.g. (width, height)
uniform float scale_factor = 4.0;


//void vertex {
	//world_uv = (MODEL_MATRIX * vec4(VERTEX.xy))
//}

void fragment() {
    //// Global screen-space coordinates (in pixels)
    //vec2 global_pos = SCREEN_UV * VIEWPORT_SIZE;
//
    //// Adjust so (0,0) is the top-left corner of the screen
    //vec2 scaled_pos = floor(global_pos / scale_factor);
//
    //// Discard pixels outside the image bounds
    //if (scaled_pos.x < 0.0 || scaled_pos.x >= image_size.x ||
        //scaled_pos.y < 0.0 || scaled_pos.y >= image_size.y) {
        //discard;
    //}
//
    //// Compute UV coordinates in the texture
    //vec2 uv = scaled_pos / image_size;
//
    //// Flip Y axis (Godot textures have Y flipped)
    //uv.y = 1.0 - uv.y;

    // Sample the color
    COLOR = texture(image_texture, UV);
}