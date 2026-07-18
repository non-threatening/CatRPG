shader_type canvas_item;

uniform float x = 4.0;
uniform float y = 3.0;
uniform vec4 color1 : source_color;
uniform vec4 stem_color: source_color;
uniform float time_scale = 5.0;

uniform float saturation = 1.0;

// to not error dream shader
uniform float progress = 0.0;

void vertex() {
	if ( VERTEX.y < -10.0 ) {
		VERTEX.x += sin( 0.5 * TIME * time_scale ) * x;
		VERTEX.y += sin( 0.3 * TIME * time_scale ) * y;
	}
}

void fragment() {
	vec4 input_color = texture( TEXTURE, UV );
	// isolate blue pen
	if ( input_color.r > 0.01 && input_color.g > 0.01 && input_color.b > 0.1 && input_color.a > 0.01) {
		COLOR.rgb = color1.rgb * input_color.rgb;
	}

	// isolate green
	if ( input_color.r < 0.7 && input_color.g > 0.3 && input_color.b < 0.7 && input_color.a > 0.5) {
		COLOR.rgb = stem_color.rgb * input_color.rgb;
	}

    COLOR.rgb = mix(vec3(dot(COLOR.rgb, vec3(0.299, 0.587, 0.114))), COLOR.rgb, saturation);
	//COLOR.a = COLOR.a;
}