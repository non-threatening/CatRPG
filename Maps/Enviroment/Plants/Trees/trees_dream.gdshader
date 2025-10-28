shader_type canvas_item;

uniform float x = 4.0;
uniform float y = 3.0;
uniform float time_scale = 5.0;

uniform float amplitude = 0.1;
uniform float frequency = 1.0;
uniform float speed = 1.0;


void vertex() {
	if ( VERTEX.y < -100.0 ) {
    	VERTEX.y += sin(UV.x * frequency + TIME * speed) * amplitude;
	}
}

void fragment() {
	vec3 inverted = 1.0 - COLOR.rgb;
	vec3 green = inverted * vec3( 0, 0.4, 0 );
	COLOR.rgb = green;
}