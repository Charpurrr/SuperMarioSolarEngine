shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, filter_nearest_mipmap;
uniform float lod: hint_range(0.0, 5) = 1.0;


void fragment(){
	vec4 color = texture(screen_texture, SCREEN_UV, lod);
	COLOR = color;
}