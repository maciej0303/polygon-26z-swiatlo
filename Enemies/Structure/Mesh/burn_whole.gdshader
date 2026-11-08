shader_type spatial;


uniform sampler2D texture_albedo : source_color;

instance uniform float progress:hint_range(0.0, 1.0, 0.01) = 0.0;
instance uniform float destroy_progress:hint_range(0.0, 1.0, 0.01) = 0.0;
uniform sampler2D gradient;
uniform sampler2D noise:repeat_enable;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
    float mask = progress;
	float n = texture(noise, UV ).r;
	
	mask = smoothstep(n * 0.5, n, mask); // przez to maska jest nierowna
	// alternatywnie moze byc jakis scrolling noise inny
	mask += random(UV  + sin(TIME * 0.000001)) * 0.8 * progress;
    vec4 tex = texture(texture_albedo, UV);
	vec3 burn_col = texture(gradient, vec2(mask,0.0)).rgb;
	vec3 final_col = mix(tex.rgb, burn_col, mask);
	
	EMISSION = burn_col * (mask);
	// moze tez ktos sie pobawic jak to z wypalaniem alfy dziala
    ALBEDO = final_col;
	//ALBEDO = vec3((normal.y));
    ALPHA = tex.a * step(destroy_progress * 1.01, n);
}

//void light(){}