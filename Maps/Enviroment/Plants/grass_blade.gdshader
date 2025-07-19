shader_type canvas_item;

uniform float x = 18.0;
uniform float y = 8.0;
uniform vec4 new_color: source_color;
uniform float time_scale = 1.0;

void vertex() {
	VERTEX.x += sin( UV.y * TIME * time_scale ) * x;
	VERTEX.y += sin( UV.y * TIME * ( time_scale * time_scale ) ) * y;
}

void fragment() {
	vec4 input_color = texture( TEXTURE, UV );
	if ( input_color.r > 0.25 && input_color.g > 0.25 && input_color.b > 0.25 && input_color.a > 0.25) {
		COLOR.rgb = new_color.rgb;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
