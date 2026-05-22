shader_type canvas_item;

uniform float speed = 2.0;
uniform float frequency = 1.0;
uniform float amplitude = 10.0;
//uniform float wave_direction = 1.0; // 1.0 or -1.0

void vertex() {
	if ( VERTEX.y < 60.0 ) {
    	//VERTEX.x += sin(UV.x * frequency + TIME * speed) * amplitude;
	//}
	
    	float wave = sin((VERTEX.y * frequency) + (TIME * speed)) * amplitude;
    
    // Apply wave to the y-axis (perpendicular to horizontal path)
    // Adjust based on if your path is horizontal or vertical
    	VERTEX.x += wave;
	}
}