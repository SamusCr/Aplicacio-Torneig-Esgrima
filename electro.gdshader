shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = vec2(UV.x - sin(TIME*80.0)*0.1, UV.y - sin(TIME *20.0)*0.02);
	//
	COLOR= texture(TEXTURE, uv);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
