shader_type canvas_item;


uniform bool enabled = true;
uniform bool invert_absolute_colors = false;


void fragment() {
	vec4 color = texture(TEXTURE, UV);

	if (color.rgb == vec3(1.0) || color.rgb == vec3(0.0)) {
		COLOR = vec4(1.0 - color.rgb, color.a);
	}

	if (!invert_absolute_colors) {
		COLOR = vec4(1.0 - color.rgb, color.a);
	}

    if (!enabled) {
		COLOR = color;
	}
}