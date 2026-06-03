shader_type canvas_item;

uniform vec4 cover_color : source_color = vec4(1.0);

void fragment() {
	vec4 input_color = texture( TEXTURE, UV );
	if ( input_color.r > 0.01 && input_color.g > 0.01 && input_color.b > 0.01 && input_color.a > 0.1) {
		COLOR.rgb = cover_color.rgb * input_color.rgb;
	}
}