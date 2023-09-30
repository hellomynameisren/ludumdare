shader_type canvas_item;

// Uniforms for customization
uniform float speed : hint_range(0.1, 3.0) = 1.0;
uniform float scale : hint_range(0.1, 10.0) = 3.0;
uniform vec4 main_color = vec4(1.0, 0.3, 0.0, 1.0); // Main lava color
uniform vec4 glow_color = vec4(1.0, 0.5, 0.0, 1.0); // Glow color
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 screen_size; // Screen size without hint

// Time variable for animation
uniform float time : hint_range(0, 100) = 0;

void vertex() {
    // Modify the UV coordinates with time for animation
    UV += time * speed;
}

void fragment() {
    // Calculate noise for the flowing effect
    float noise = texture(SCREEN_TEXTURE, FRAGCOORD.xy / screen_size).r;
    float flow = texture(SCREEN_TEXTURE, UV * scale + noise).r;

    // Mix the main color and the glow color based on the noise value
    COLOR = mix(main_color, glow_color, flow);
}