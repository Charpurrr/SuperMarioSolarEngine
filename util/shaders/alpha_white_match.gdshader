shader_type canvas_item;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float threshold = 0.99; // Define white threshold
    
    // Check if the pixel is white (all RGB channels close to 1)
    bool is_white = tex_color.r > threshold && tex_color.g > threshold && tex_color.b > threshold;
    
    if (is_white) {
        // Keep white pixels
        COLOR = tex_color;
    } else {
        // Set background alpha to the same as the white pixels
        COLOR = vec4(tex_color.rgb, 0.0);
    }
}
