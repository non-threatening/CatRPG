shader_type canvas_item;

uniform vec4 cover_color : source_color = vec4(1.0);
uniform vec4 eye_color : source_color = vec4(1.0);

void fragment() { // Called for every pixel the material is visible on.
	vec4 input_color = texture( TEXTURE, UV );
	vec4 output_color = vec4( input_color.r, input_color.g, input_color.b, input_color.a );
	if ( output_color.r > 0.8 && output_color.g < 0.75 && output_color.b < 0.75 ) {
		output_color = vec4( eye_color ); // output_color is the eye isolated
	}
	vec4 cover_eye_mix = output_color * vec4( cover_color );	
	
	COLOR = cover_eye_mix;

}