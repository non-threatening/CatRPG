shader_type canvas_item;

uniform float y = 36.0;
uniform float time_scale = 6.66;

void vertex() {
	VERTEX.y += sin( TIME * ( time_scale ) ) * y;
}
