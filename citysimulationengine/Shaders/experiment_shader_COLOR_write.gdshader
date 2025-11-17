shader_type canvas_item;
// goal is to determine what colors the COLOR van output. ie can I ouput and then recover negetive colors?, can I output highly precise colors? up to 25 000 000

// need subviewportcontrainer -> subviewport to take screen shots
// negetives do get clamped and are unrecoverabel. 
// so now I need to figure out how large the number i can encode on a single chanel ( I know 0 -. 255 is probably good)
// it does not need to be in a containter and actually visible to be screen shot. 

// vec4(255,0,0,1); -> COlor(1,0,0,1)
// vec4(256,0,0,1); -> COlor(1,0,0,1)
// vec4(1000,0,0,1); -> COlor(1,0,0,1)
// vec4(100,0,0,1); -> COlor(1,0,0,1)

// vec4(1/255,0,0,1); -> COlor(1/255,0,0,1)* 255 -> 1
// vec4(254/255,0,0,1); -> COlor(254/255,0,0,1)* 255 -> 255
// vec4(511/25000000,0,0,1); -> COlor(1?,0,0,1)* 25000000 -> 25000000? (unrecoverable)
// vec4(1/25000000,0,0,1); -> COlor(0.00392156885937,0,0,1)* 25000000 -> 98039.2214842141? (unrecoverable)

// vec4(254/512.0,0,0,1); -> COlor(0.99607843160629,0,0,1)* 512.0 -> 509.992156982422 (unrecoverable)

// 254/256 -> 0.99607843160629 recovers 254.996078491211 (too close for comfort)
// 254/255 -> 0.99607843160629 recovers 254.000000059605 (good)





uniform float num = 255.0;

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = vec4(254.0/num,0,0,1);
}

