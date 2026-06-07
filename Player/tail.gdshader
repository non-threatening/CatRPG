shader_type canvas_item;

uniform sampler2D noise_texture : filter_linear_mipmap, repeat_enable;
uniform float paper_texture_scale : hint_range(0.1, 10.0) = 0.25;
uniform vec4 body_color : source_color = vec4( 0.7, 0.02, 0.45, 1.0);


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
	vec4 thing = COLOR * vec4(COLOR.r + body_color.r, COLOR.g + body_color.g, COLOR.b + body_color.b, 2);
	COLOR = thing;

}