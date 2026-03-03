shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4( 0.5, 0.0, 0.0, 1.0 );
uniform float outline_thickness : hint_range( 0.0, 15.0 ) = 0.0;
uniform float alpha_threshold : hint_range(0.0, 0.9) = 0.5;

uniform vec4 cover_color : source_color = vec4(1.0);
uniform vec4 eye_color : source_color = vec4(1.0);

uniform float x = 0.5;
uniform float y = 1.0;
uniform float time_scale = 2.666;


float has_solid_neighbor( sampler2D texture_sample, vec2 uv_coord, vec2 pixel_size ) {
	vec2 offset = outline_thickness * pixel_size;
	float sum_alpha = 0.0;

	sum_alpha += texture( texture_sample, uv_coord + vec2( 1.0, 0.0 ) * offset ).a;
	sum_alpha += texture( texture_sample, uv_coord + vec2( -1.0, 0.0 ) * offset ).a;
	sum_alpha += texture( texture_sample, uv_coord + vec2( 0.0, 1.0 ) * offset ).a;
	sum_alpha += texture( texture_sample, uv_coord + vec2( 0.0, -1.0 ) * offset ).a;
	//
	// Diagonal, less weight
	sum_alpha += texture( texture_sample, uv_coord + vec2( 1.0, 0.0 ) * offset ).a;
	sum_alpha += texture( texture_sample, uv_coord + vec2( -1.0, 0.0 ) * offset ).a;
	sum_alpha += texture( texture_sample, uv_coord + vec2( 0.0, 1.0 ) * offset ).a;
	sum_alpha += texture( texture_sample, uv_coord + vec2( 0.0, -1.0 ) * offset ).a;

	return smoothstep( 0.0, 1.0, sum_alpha);
}


void vertex() {
	if ( VERTEX.y < 2.0 ) {
		VERTEX.x += sin( TIME * time_scale ) * x;
		VERTEX.y += sin( TIME * ( time_scale * 1.25 ) ) * y;
	}
}


void fragment() {
	vec4 input_color = texture( TEXTURE, UV );
	if ( input_color.r > 0.01 && input_color.g > 0.01 && input_color.b > 0.01 && input_color.a > 0.1) {
		COLOR.rgb = cover_color.rgb * input_color.rgb;
	}
	input_color = COLOR;
	if ( input_color.r > 0.4 && input_color.g < 0.2 && input_color.b < 0.2 ) {
		COLOR.rgba = eye_color.rgba;
	}

	float outline_mask = has_solid_neighbor( TEXTURE, UV, TEXTURE_PIXEL_SIZE );
	float alpha_blend_factor = smoothstep( 0.0, alpha_threshold, COLOR.a );
	COLOR.rgb = mix( outline_color.rgb, COLOR.rgb, alpha_blend_factor );
	COLOR.a = max( COLOR.a, outline_mask );

	//if ( alpha_threshold != 0.0 ){
		//vec3 inverted = 1.0 - COLOR.rgb;
		//vec3 green = inverted * vec3( 0, 0.666, 0 );
		//COLOR.rgb = green;
		//}
}
