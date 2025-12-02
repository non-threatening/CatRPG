shader_type canvas_item;
//render_mode blend_add; //Comment this if you want another render mode.
uniform vec2 center = vec2(0.5);
uniform float size: hint_range(0.0,5.0) = 1.0; //change size to well, change the size of your gradient
uniform vec2 squishness = vec2(1.0); // how squashed your gradient is

//choose colors in the inspector
uniform vec4 color1 : source_color = vec4( 0.2, 0.82, 0.0, 0.28);
uniform vec4 color2 : source_color = vec4( 0.11, 0.98, 0.0, 0.22);
uniform vec4 color3 : source_color = vec4( 0.35, 0.99, 0.33, 0.74);

//choose how far the colors are from each other in the inspector
uniform float step1 : hint_range(0.0,1.0) = 0.15;
uniform float step2 : hint_range(0.0,1.0) = 0.225;
uniform float step3 : hint_range(0.0,1.0) = 0.275;

uniform float amplitude = 0.1;
uniform float frequency = 1.0;
uniform float speed = 1.0;


void fragment() {
	vec4 input_color = texture( TEXTURE, UV );
	vec3 inverted = 1.0 - input_color.rgb;
	vec4 add_alpha = vec4( inverted, 1 );

	if ( input_color.a > 0.5) {
		float dist = distance(center*squishness,UV*squishness);
		vec4 color = mix(color1, color2, smoothstep(step1*size, step2*size, dist));
		color = mix(color, color3, smoothstep(step2*size, step3*size, dist));
		COLOR = add_alpha.rgba * color;
	}
}

void vertex() {
	if ( VERTEX.y < -100.0 ) {
    	VERTEX.y += sin(UV.x * frequency + TIME * speed) * amplitude;
	}
}