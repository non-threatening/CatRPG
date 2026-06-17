shader_type canvas_item;

// Noise texture
uniform sampler2D noise_texture: repeat_enable, filter_nearest;
uniform float saturation = 1.0;
void vertex() {
}

void fragment() {
	COLOR = vec4(texture(noise_texture, UV) * COLOR);
	
	COLOR.rgb = mix(vec3(dot(COLOR.rgb, vec3(0.299, 0.587, 0.114))), COLOR.rgb, saturation);
	//COLOR.a = COLOR.a;
}