shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D viewport_texture : hint_default_white;

void fragment() {
	vec3 tex = texture(viewport_texture, SCREEN_UV).rgb;
	//ALBEDO = vec3(1.0) - (vec3(1.0) - tex) * (vec3(1.0) - tex);
	//ALBEDO = tex;
	//ALBEDO = tex * tex + vec3(0.003);
	ALBEDO = tex * tex;
}