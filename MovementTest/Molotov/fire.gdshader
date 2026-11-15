shader_type spatial;
render_mode blend_add, depth_prepass_alpha;

uniform float aspect_ratio = 1.0;
uniform sampler2D gradient;
uniform sampler2D noise:repeat_enable;
uniform sampler2D noise2:repeat_enable;


float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

float blend(in float base, in float blend)
{
	//float limit = step(0.5, blend);
	//return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
	return abs(base + blend - 1.0);
	//return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

void fragment() {
	vec2 uv = UV;
	uv.y /= aspect_ratio;
	float t = TIME * 0.4;
	float n = texture(noise, uv + FRAGCOORD.zx + vec2(0.0, t)).r;
	float n2 = texture(noise2, uv + vec2(t * 0.1, t * PI * 0.4)).r;
	float mask = UV.y;
	mask *= 1.0 - abs(UV.x - 0.5) * 2.0;
	//mask *= 2.0;
	mask = smoothstep(0.01, 0.9, mask);
	
	mask *= blend(n, n2);
	//mask *= 2.0;
	mask *= (1. - random(vec2(uv + t * 0.1)) * mask);
	mask *= COLOR.r;
	ALBEDO = texture(gradient, vec2(mask)).rgb;
	ALPHA = mask > 0.01 ? 1.0 : 0.0;
	EMISSION = ALBEDO * (1.0 + mask * 10.0);
	//EMISSION = vec3(1.0, 0.5, 0.0) * 100.0;
}

//void light() {
	//DIFFUSE_LIGHT = texture(gradient, vec2(0.0)).rgb;
	//SPECULAR_LIGHT = vec3(0.0);
//}
