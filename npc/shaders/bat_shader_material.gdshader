shader_type canvas_item;
uniform vec4 eye_color : source_color = vec4(1.0);
uniform vec4 body_color : source_color = vec4( 0.7, 0.02, 0.45, 1.0);

uniform sampler2D noise_texture : filter_linear_mipmap, repeat_enable;
uniform float paper_texture_scale : hint_range(0.1, 10.0) = 0.25;

uniform float x = 0.5;
uniform float y = 1.0;
uniform float time_scale = 2.666;


void fragment() {
	// 2. Sample the original texture behind the sprite
	vec4 base_color = texture(TEXTURE, UV);

	if ( COLOR.a > 0.05) {
	    // 1. Sample noise to warp the UV coordinates (bleeding effect)
	    vec2 noise_val = texture(noise_texture, UV * paper_texture_scale).rg;

	    // 3. Create watercolor pigment buildup (darker edges)
	    float pigment_edge = smoothstep(0.1, 0.5, 0.666);
	    // 4. Combine base color with the paper/noise texture
	    vec4 watercolor_color = base_color.rgba * (1.0 - pigment_edge * noise_val.r);
    COLOR = vec4(watercolor_color);
	}
	vec4 thing = COLOR * vec4(COLOR.r + body_color.r, COLOR.g + body_color.g, COLOR.b + body_color.b, 1);
	COLOR = thing * vec4(1, 1, 1, 3);
	

	if ( base_color.r < 0.3 && base_color.g > 0.75 && base_color.b < 0.3 ) {
		COLOR = eye_color.rgba;
	}
}

void vertex() {
	if ( VERTEX.y > -29.0 ) {
		VERTEX.x += sin( TIME * time_scale ) * x;
		VERTEX.y += sin( TIME * ( time_scale * 1.25 ) ) * y;
	}
}
