shader_type canvas_item;

uniform float speed = 3.5;

void fragment() {
	vec4 input_color = texture( TEXTURE, UV );
	float alpha = input_color.a * sin( speed * TIME );
	if (alpha > 0.666) {
		COLOR.a = 0.666;
	} else {
		COLOR.a = alpha;
	}
}