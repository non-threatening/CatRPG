shader_type canvas_item;

uniform sampler2D color: source_color;
uniform sampler2D wave_color: source_color;

uniform float wave_amplitude = 0.25;
uniform float wave_frequency = 50.0;
uniform float wave_speed = 9.0;

uniform float left_falloff = 1.0;
uniform float right_falloff = 1.0;

void fragment() {
    float dist_left = clamp(0.5 - UV.x, 0.0, 0.5) * 2.0;
    float dist_right = clamp(UV.x - 0.5, 0.0, 0.5) * 2.0;

    float falloff_left = pow(1.0 - dist_left, left_falloff);
    float falloff_right = pow(1.0 - dist_right, right_falloff);

    float center_falloff = (UV.x <= 0.5) ? falloff_left : falloff_right;

    float amp = wave_amplitude * center_falloff;
    float y = 0.5 + sin(UV.x * wave_frequency + TIME * wave_speed) * amp;

    float thickness = 0.125;
    float dist = abs(UV.y - y);

	vec3 c = texture(color, UV).rgb;

    float alpha = smoothstep(thickness, 0.0, dist);
    vec4 wave = vec4(c, alpha);

	vec4 wc = texture( wave_color, UV );
	COLOR = wave - wc;

}
