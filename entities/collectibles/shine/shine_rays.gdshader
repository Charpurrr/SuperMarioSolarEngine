shader_type canvas_item;
render_mode unshaded, blend_add;

// x is the starting rotation of the ray in radians,
// y is the arc of the ray in radians
// z is the length of the ray
// w is direction of motion of the ray (only looks at the sign)
uniform vec4 ray_map[24];

uniform sampler2D[4] ray_masks: filter_linear;

uniform float rays_offset = 0.0;
uniform float rays_speed_scale = 1.0;

uniform bool disable_masks = false;
uniform bool pixelate = false;


vec2 polar(vec2 uv) {
	return vec2(atan(uv.y - .5, uv.x - .5) + PI, distance(uv, vec2(0.5)) * 2.0);
}


float angle_dist(float a, float b) {
	float diff = abs(a - b);
	return min(diff, TAU - diff);
}


float random (vec2 st) {
	return fract(sin(dot(st.xy,
		vec2(12.9898,78.233))) * 43758.5453123);
}


int map(int x, int in_min, int in_max, int out_min, int out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}


float rays(vec2 uv, vec4 rays[24], float offset, float speed_scale) {
	vec2 polar_uv = polar(uv);
	float alpha = 0.0;
	
	for (int i = 0; i < rays.length(); i++) {
		vec4 ray = rays[i];
		
		float ray_distance = ray.z;
		float ray_speed = .4 * sign(ray.w) * (ray_distance);
		float rotation = mod(polar_uv.x + offset + (ray_speed * TIME * speed_scale), TAU);
		float ray_rotation = mod(ray.x, TAU);
		float ray_width = ray.y;
		
		// calculate index for mask
		int ray_mask_index = int(mod(float(i), float(ray_masks.length())));
		
		float dist = angle_dist(rotation, ray_rotation);
		if (dist <= ray_width * 0.5 && ray_distance > 0.0) {
			float power = max(0.0, 1.0 - polar_uv.y / ray_distance);
			float dist_to_ray_center = rotation - ray_rotation;
			float dist_modifier = (polar_uv.x - dist_to_ray_center) / TAU;
			float mask = texture(ray_masks[ray_mask_index], vec2(dist_modifier, polar_uv.y)).r;
			
			if (disable_masks) {
				alpha += power;
			} else {
				alpha += power * mask;
			}
		}
	}
	return clamp(alpha, 0.0, 1.0);
}


void fragment() {
	if (pixelate) {
		vec2 uv = ceil(UV * vec2(textureSize(TEXTURE, 0))) / vec2(textureSize(TEXTURE, 0) + ivec2(1));
		float alpha = rays(uv, ray_map, rays_offset, rays_speed_scale);
		COLOR.a = alpha;
		//COLOR.a = step(0.001, ray(uv, ray_map_1, ray_mask_1, ray_1_offset, ray_1_offset));
	} else {
		COLOR.a = rays(UV, ray_map, rays_offset, rays_speed_scale);
		//COLOR.a = ray(UV, ray_map_1, ray_mask_1, ray_1_offset, ray_1_speed);
	}
}