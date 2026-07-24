shader_type canvas_item;

uniform float x = 0.5;
uniform float y = 1.0;
uniform float time_scale = 2.666;

void vertex() {
	//if ( VERTEX.y < 0.0 ) {
		VERTEX.x += sin( TIME * time_scale ) * x;
		VERTEX.y += sin( TIME * ( time_scale * 1.25 ) ) * y;
	//}
}

void fragment() {
	//vec4 input_color = texture( TEXTURE, UV );
	//if ( input_color.r > 0.25 && input_color.g > 0.25 && input_color.b > 0.25 && input_color.a > 0.25) {
		//COLOR.rgb = new_color.rgb;
	//}
}
