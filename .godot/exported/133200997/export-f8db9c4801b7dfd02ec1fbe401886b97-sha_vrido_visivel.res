RSRC                    Shader            ��������                                                  resource_local_to_scene    resource_name    code    script           local://Shader_8niqd �          Shader            shader_type spatial;
render_mode blend_mix,depth_test_disabled,cull_disabled,diffuse_burley,specular_schlick_ggx,depth_prepass_alpha;
uniform vec4 albedo : source_color = vec4(0.906, 0.906, 0.906, 0.149);
uniform vec4 albedo2 : source_color = vec4(0.514, 0.525, 0.906, 0.247);
uniform float blend : hint_range(0.0, 1.0);
uniform float point_size : hint_range(0,128);
uniform float roughness : hint_range(0,1);
uniform sampler2D texture_metallic : hint_default_white,filter_linear_mipmap,repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float specular;
uniform float metallic;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;
	ALBEDO = mix(albedo.rgb, albedo2.rgb, blend);
	float metallic_tex = dot(texture(texture_metallic,base_uv),metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	vec4 roughness_texture_channel = vec4(1.0,0.0,0.0,0.0);
	float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
	ALPHA *= mix(albedo.a, albedo2.a, blend);
}
       RSRC