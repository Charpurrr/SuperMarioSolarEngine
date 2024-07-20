shader_type canvas_item;

uniform vec2 bounding_box;

uniform vec3 color_progress : source_color;
uniform vec3 color_background : source_color;
uniform vec3 color_seperator : source_color;

uniform float segment_count = 3;
uniform float segment_width = 10.0;

uniform float value = 0;


void fragment() {
	float pixel_size_width = 1.0 / bounding_box.x;

	if (UV.x + UV.y < 1.0) {
		COLOR.a = 0.0;
	}

	COLOR.rgb = color_progress;

	if (UV.x > value / segment_count){
		COLOR.rgb = color_background;
	}

	float width_pixels = segment_width * pixel_size_width;

	if (mod(UV.x, 1.0 / float(segment_count)) < width_pixels){

		if (UV.x > width_pixels && UV.x < 1.0 - width_pixels){
			COLOR.rgb = color_seperator;
		}
	}
}