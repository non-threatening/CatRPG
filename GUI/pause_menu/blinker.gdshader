shader_type canvas_item;

void fragment() {
	vec4 input_color = texture( TEXTURE, UV );
	float alpha = input_color.a * sin( 2.5 * TIME );
	if (alpha > 0.3) {
		COLOR.a = 0.666;
	} else {
		COLOR.a = alpha;
	}
}