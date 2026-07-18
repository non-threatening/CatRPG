shader_type canvas_item;

// Noise texture
uniform sampler2D noise_texture: repeat_enable, filter_nearest;

void vertex() {
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	COLOR = vec4(texture(noise_texture, UV) * color);
}