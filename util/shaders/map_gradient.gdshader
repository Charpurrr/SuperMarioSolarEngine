shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture: hint_screen_texture, filter_nearest_mipmap;

uniform float blur_lod: hint_range(0.0, 5) = 0;
uniform float mix_amount = 1.0;

uniform sampler2D gradient: hint_default_black;


void fragment(){
	vec4 color = texture(screen_texture, SCREEN_UV, blur_lod);

	float grayscale_val = dot(color.rgb, vec3(0.299, 0.587, 0.144));
	vec3 sampled_color = texture(gradient, vec2(grayscale_val, 0.0)).rgb;

	COLOR.rgb = mix(color.rgb, sampled_color, mix_amount);
	COLOR.a = color.a;
}