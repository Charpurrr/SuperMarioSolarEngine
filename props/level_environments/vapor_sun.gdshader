shader_type canvas_item;

uniform float line_height_min : hint_range(0.0, 1.0) = 0.01;
uniform float line_height_max : hint_range(0.0, 1.0) = 0.1;
uniform int num_lines : hint_range(1, 10) = 6;
uniform float speed : hint_range(0.0, 1.0) = 0.1;
uniform float vertical_origin : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float alpha = tex_color.a;
    
    if (UV.y > vertical_origin) {
        float moving_position = mod(TIME * speed, 1.0 + line_height_max);
        for (int i = 0; i < num_lines; i++) {
            float line_position = mod(moving_position + float(i) / float(num_lines), 1.0 + line_height_max) - line_height_max;
            float adjusted_position = vertical_origin + (1.0 - vertical_origin) * line_position;
            float line_height = mix(line_height_max, line_height_min, clamp(line_position, 0.0, 1.0));

            float line_alpha = step(adjusted_position - line_height / 2.0, UV.y) - step(adjusted_position + line_height / 2.0, UV.y);
            alpha *= (1.0 - line_alpha);
        }
    }

    COLOR = vec4(tex_color.rgb, alpha);
}