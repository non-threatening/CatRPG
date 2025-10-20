shader_type canvas_item;

uniform float x = 4.0;
uniform float y = 3.0;
uniform float time_scale = 5.0;


void vertex() {
	if ( VERTEX.y < -10.0 ) {
		VERTEX.x += sin( 0.5 * TIME * time_scale ) * x;
		VERTEX.y += sin( 0.3 * TIME * time_scale ) * y;
	}
}

void fragment() {
	vec3 inverted = 1.0 - COLOR.rgb;
	vec3 green = inverted * vec3( 0, 0.666, 0 );
	COLOR.rgb = green;
}