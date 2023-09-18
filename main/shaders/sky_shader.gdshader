shader_type sky;

uniform vec3 sky_color : source_color;
uniform vec3 horizon_color : source_color;

void sky() {
	float col = clamp(EYEDIR.y / 0.05, 0.0, 1.0);
	vec3 final_color = mix(horizon_color, sky_color, col);
	COLOR = final_color * LIGHT0_ENERGY;
}
