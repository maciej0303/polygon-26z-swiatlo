shader_type spatial;
render_mode unshaded, shadows_disabled, ambient_light_disabled, 
	blend_add, fog_disabled;

uniform float strength:hint_range(0.0, 1.0, 0.001) = 1.0;
uniform float blend:hint_range(0.0, 1.0, 0.001) = 1.0;
uniform float grit:hint_range(0.0, 1.0, 0.001) = 1.0;
uniform vec3 color:source_color;
uniform float max_alpha:hint_range(0.0, 1.0, 0.001) = 0.5;


float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}


void fragment() {
	float f = dot(NORMAL, VIEW);
	f += grit * (0.5 - random(vec2(NODE_POSITION_WORLD.y + UV.y)  + fract(TIME * 0.0000005)));
	
	float s = 1.0 - strength;
	f = smoothstep(s * (1.0 - blend), s, f);
	ALPHA = f * max_alpha;
	ALBEDO = color;
	//ALPHA = 0.9;
	//EMISSION = color * 5000.0;
}

void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
}
