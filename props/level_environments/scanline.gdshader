shader_type canvas_item;

group_uniforms BackgroundColor;
/** Color to apply to the sprite as background, use alpha = 0.0 to remove this. */
uniform vec4 fill_color : source_color = vec4(0.5, 0.5, 0.5, 1.0);
/** If True, scan lines will use the texture's alpha value, so they'll appear
to be within the texture. If false, the scan lines will use the entire sprite
rectangle, looking like they're above the texture. */
uniform bool use_texture_alpha = false;
group_uniforms ScanLines;
/** Color to use for the scanning lines. */
uniform vec4 line_color : source_color = vec4(0.0, 1.0, 0.0, 1.0);
/** Scanning lines thickness. */ 
uniform float line_thickness : hint_range(0.0, 1.0) = 0.01;
group_uniforms ScanLinesMovement;
/** Scan lines speed. */
uniform float speed : hint_range(0.0, 20.0) = 1.0;
/** Restrict scan lines in X and Y to the bounds specified by their vectors.
Texture goes from 0.0 to 1.0, so the default value does not restrict. */
uniform vec2 x_line_bounds = vec2(0.0, 1.0); 
uniform vec2 y_line_bounds = vec2(0.0, 1.0);

float highlight(float point, float progress) {
	return smoothstep(progress - line_thickness, progress, point) - 
			smoothstep(progress, progress + line_thickness, point);
}

// Convert a point in the UV space to the color needed to show a crosshair.
float point_to_color(vec2 uv, vec2 point) {
	return highlight(uv.y, point.y) + highlight(uv.x, point.x);
}

// Random function from https://godotshaders.com/snippet/random-value.
float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

// This runs for every vertex in the sprite.
void vertex() {
	// Just fill the background color.
	COLOR = fill_color;
}

/*
	This will run for every pixel on the texture.
	We're going to use TIME as an animation variable here. We're going to generate
	random vec2 at each interval of TIME and slowly interpolate the scan lines
	between those points.
*/
void fragment() {
	// Get the modifed TIME, adjusted with the speed. Greaer speeds means the
	// integer part will change more frequenty.
	float time = speed*TIME;
	float floor_time = floor(time);
	// Get the next floor time, we're going to use this to know where to trasition
	// to.
	float next_floor_time = floor_time + 1.0;
	// Get the fraction portion of the adjusted TIME. This will vary qickly and
	// will serve as a nice interpolation variable. This will always be from
	// 0.0 to 1.0.
	float fract_time = fract(time);
	
	// Generate a random point between vec2(lower_bound) and vec2(upper_bound). This
	// will be the start vector from where the scan lines should start.
	vec2 rand_vector = vec2(
		mix(x_line_bounds.x, x_line_bounds.y, random(vec2(floor_time, 0.0))),
		mix(y_line_bounds.x, y_line_bounds.y, random(vec2(0.0, floor_time)))
	);
	// Generate the next random point, this will be the end vector to where the
	// scan lines arrive.
	vec2 next_rand_vector = vec2(
		mix(x_line_bounds.x, x_line_bounds.y, random(vec2(next_floor_time, 0.0))),
		mix(y_line_bounds.x, y_line_bounds.y, random(vec2(0.0, next_floor_time)))
	);
	// Generate the actual point to draw now. This is a simple interpolation between
	// the start vector and the end vector.
	vec2 moving_point = mix(rand_vector, next_rand_vector, fract_time);
	// Get the color multiplier, this will tell us if we need to draw a line or not. 
	float color_mult = point_to_color(UV, moving_point);
	// Get the sprite's texture, mapped to its UV.
	vec4 texture_color = texture(TEXTURE, UV);
	// Apply the color. We use the color multiplier to know if this is a scan line or not.
	// If it's not a scan line the the multiplier will be 0.0, so no extra color is added.
	// The multiplier uses smoothstep, so it gracefully transitions to the scan line color.
	COLOR += color_mult * vec4(
		line_color.rgb,
		texture_color.a * float(use_texture_alpha) + (1.0 - float(use_texture_alpha)));
}