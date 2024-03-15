shader_type spatial;
render_mode unshaded, cull_back;

uniform sampler2D depth_texture : source_color, hint_depth_texture;
uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D mask_texture : source_color, hint_default_black;
uniform vec3 point_highlight;
uniform float point_size = 1.0;

varying mat4 CAMERA;

float rand(vec2 co){
	return fract(sin(dot(co ,vec2(12.9898,78.233))) * 43758.5453);
}

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
	CAMERA = INV_VIEW_MATRIX;
}

void fragment() {
	float depth = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	vec4 world = CAMERA * INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	vec3 world_position = world.xyz / world.w;
	
	vec3 screen = texture(screen_texture, SCREEN_UV).rgb;
	
	vec3 modified = vec3(1.0) - (screen / (vec3(1.0) - screen));
	
	float mask = smoothstep(point_size / 2.0 * rand(SCREEN_UV * TIME), point_size, length(world_position - point_highlight));
	mask = clamp(mask + texture(mask_texture, SCREEN_UV).a, 0.0, 1.0);
	
	vec3 display = mix(modified, screen, mask);
	
	ALBEDO = display;
	//ALBEDO = vec3(mask);
}
