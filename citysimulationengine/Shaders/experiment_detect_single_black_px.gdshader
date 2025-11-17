shader_type canvas_item;

// goal: I need to dectect a single color on a texture and then output a bool if it exists.

//goal give a gray image with a sinlge black pixel, passed to this via the inspector
//create a 100 x 100 region colored black if the blakc px in texture was detected. I will only be reading the ouptut at its top left corner on cpu. but 100 x 100 for visual
// white region if black px not detected

// this does not work

uniform sampler2D tex;

void fragment() {
	vec4 c = texture(TEXTURE, UV);



	if ( abs(c - vec4(0,0,0,1)) < vec4(.001)) {

	}

    if (abs(c.r - (252.0 / 255.0)) < 0.00001) {
        COLOR = vec4(0,0,0,1); // found
    } else {
        COLOR = vec4(1,1,1,1); // not found
    }

	// Called for every pixel the material is visible on.
}
