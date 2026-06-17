shader_type canvas_item;

uniform sampler2D rgba_mask : source_color;
uniform float mask_edge1 = 0.0;
uniform float mask_edge2 = 1.0;
uniform vec3 lightDir;
uniform vec3 lightColor : source_color = vec3(1.0);

uniform float LOD = 0.0;

/////////////// Red Channel //////////////////////////////
group_uniforms Red_Channel;
uniform sampler2D r_diffuse : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D r_normal : hint_normal, filter_linear_mipmap, repeat_enable;
uniform float r_n_str = 1.0;
uniform float r_size = 1.0;

////////////// Green Channel //////////////////////////////
group_uniforms Green_Channel;
uniform sampler2D g_diffuse : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D g_normal : hint_normal, filter_linear_mipmap, repeat_enable;
uniform float g_n_str = 1.0;
uniform float g_size = 1.0;

////////////// Blue Channel //////////////////////////////
group_uniforms Blue_Channel;
uniform sampler2D b_diffuse : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D b_normal : hint_normal, filter_linear_mipmap, repeat_enable;
uniform float b_n_str = 1.0;
uniform float b_size = 1.0;


////////////// Black Channel //////////////////////////////
group_uniforms Background_Channel;
uniform sampler2D background_diffuse : source_color, filter_linear_mipmap, repeat_enable;
uniform vec3 back_color : source_color = vec3(1.0);
uniform float back_n_str = 1.0;
uniform float background_size = 1.0;


vec3 calculateLambertLight(vec3 normal) {
	vec3 n = normalize(normal);
	vec3 l = normalize(lightDir);

	float diff = max(dot(n, l), 0.0);

	return lightColor * diff;
}

vec4 pbr(
	sampler2D diffuse,
	sampler2D normal,
	float nstr,
	vec2 uv
){
	vec4 col = textureLod(diffuse, uv, LOD);
	vec3 nor = textureLod(normal, uv, LOD).rgb;

	nor = nor * 2.0 - 1.0;

	vec3 flat_normal = vec3(0.0, 0.0, 1.0);

	vec3 final_normal = normalize(mix(flat_normal, nor, nstr));

	vec3 diff = calculateLambertLight(final_normal);
	col.rgb *= diff;

	return col;
}

vec3 blendColors(vec4 mask, vec3 color1, vec3 color2, vec3 color3, vec3 background) {
    vec3 result = background;

    result = mix(result, color1, mask.r);
    result = mix(result, color2, mask.g);
    result = mix(result, color3, mask.b);

    return result;
}

void fragment() {
	vec4 maskColor = texture(rgba_mask, UV);
	vec4 mask = smoothstep(vec4(mask_edge1), vec4(mask_edge2), maskColor);


	vec4 red    =  pbr(r_diffuse, r_normal, r_n_str, UV*r_size);
	vec4 green  =  pbr(g_diffuse, g_normal, g_n_str, UV*g_size);
	vec4 blue   =  pbr(b_diffuse, b_normal, b_n_str, UV*b_size);

	vec4 background = textureLod(background_diffuse, UV*background_size, LOD);

	vec3 mix_all = blendColors(mask, red.rgb, green.rgb, blue.rgb, background.rgb*back_color);
	if (mask.a < 0.5) {
		discard;
	}
	mix_all *= dot(mask.rgb*0.1+0.4, vec3(1.0));
	COLOR = vec4(mix_all,1.0);
}
